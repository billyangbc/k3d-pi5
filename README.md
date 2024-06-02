# Install k3d on raspberry pi 5

This document will guide to install a multiple nodes cluster on raspberry pi 5.

## Install docker

```sh
sudo apt update && sudo apt install docker.io docker-compose
sudo usermod -aG docker $USER
docker --version
docker-compose --version
docker ps --all
sudo apt update && sudo apt dist-upgrade
```

## Enable cgroup memory
You enable it by simply appending `cgroup_memory=1 cgroup_enable=memory` to `/boot/firmware/cmdline.txt`.

## Install kubectl

```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

## Install k3d

```sh
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```

# Enable ssh (optional)

```sh
sudo apt-get update
sudo apt-get install openssh-server
sudo ufw allow 22
```

## Check k3d by creating a cluster

```sh
k3d cluster create k3d-cluster \
    --volume /media/bill/Data-4TB/k3dvol:/data \
    --volume /media/bill/SSD-DATA/k3dvol:/ssd \
    --servers 1 \
    --agents 2 \
    --disable=traefik \
    --tls-san=192.168.1.85
```


## Delete k3d cluster

```sh
k3d cluster delete k3d-cluster
```

## Using ansible to install k3d

```sh
ansible-playbook -i hosts playbook.yml --ask-pass --ask-become-pass
```

## Merge kube config into local kube config file
Once the ansible playbook is done, there should be a file with name `k3d-kube-config` in the folder where ansible playbook runs.
Merge the content into local kube config (~/.kube/config),then use command to check:
```sh
kubectl get nodes
```

## Run ansible with passwordless authentication (optional)

### step 1: Generating SSH keys

On the server which ansible runs on, create SSH keys by using the command `ssh-keygen`. The command generates three files:

* authorized_keys: A file storing the public keys form other hosts (manually create it if not existing) 
* id_ed25519.pub: public key
* id_ed25519: private key

### step 2: Copy public key to remote host
We will copy the public key `id_ed25519.pub` to the remote host's `authorized_keys` file. Using the following commands:

On local host:
```sh
cd ~/.ssh
cat id_ed25519.pub
# cat id_ed25519.pub | pbcopy
```

On the remote host:
```sh
vim ~/.ssh/authorized_keys
# paste copied content
```

### step 3: test and run ansible

For testing:
```sh
ssh bill@192.168.100.205
# note: no password is needed
```

Run ansible:
```sh
ansible-playbook -i hosts playbook.yml
```

## Check created deployment with PV
```sh
kebuctl get pv,pvc,deploy,pods -o wide
```

Goto a pod and ouput hostname to a file
```sh
k exec -it __POD_NAME -- sh
df -h
echo $(hostname) >> /ssd/hostnames-ssd.txt
echo $(hostname) >> /data/hostnames-data.txt
exit
```
Goto another pod and run above commands

On remote host, check if files exist on disk:
```sh
ls -la /media/bill/SSD-DATA/k3dvol/
ls -la /media/bill/Data-4TB/k3dvol/
```


## Tips:
When build docker for multiple architecture on ubuntu, `Docker Desktop` will be needed.
However, when upgrade to ubuntu 24.04, the `Docker Desktop` is not able to start.
Here is a workaround:

```sh
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
systemctl --user restart docker-desktop
```