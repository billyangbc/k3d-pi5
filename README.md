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
    --volume /media/bill/SSD-DATA/k3dvol-01:/ssd \
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
ssh-copy-id user@hostname.example.com
#cd ~/.ssh
#cat id_ed25519.pub
#cat id_ed25519.pub | pbcopy
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

### 1. Docker Desktop is not able to start on ubuntu 24.04
When build docker for multiple architecture on ubuntu, `Docker Desktop` will be needed.
However, when upgrade to ubuntu 24.04, the `Docker Desktop` is not able to start.
Here is a workaround:

```sh
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
systemctl --user restart docker-desktop
```

### 2. ssh id copy and remove
You can use `ssh-copy-id` to copy local ssh public key to remote server, so that you can login without password, here are some tips.

If you have done a ssh-copy-id like:
```sh
remote='user@email.com'
ssh-copy-id -i $remote
```

So you can access this remote machine without using a password:
```sh
ssh $remote
```

To remove the public key from remote server,
```sh
idssh=$(awk '{print $2}' ~/.ssh/id_rsa.pub)
ssh $remote "sed -i '\#$idssh#d' .ssh/authorized_keys"
```

### 3. Initialize pass issue for `dockr login`
```sh
pass remove -rf docker-credential-helpers
#OR    rm -rf ~/.password-store/docker-credential-helpers
gpg --generate-key
gpg --full-gen-key
pass init <generated gpg-id public key>
```

### 4. Build docker image for multiple platform (https://www.docker.com/blog/multi-arch-images/)
```sh
docker buildx build --platform linux/arm64 -t billyangbc/hellodocker:bookworm-arm64 -f Dockerfile . --no-cache
#push to docker.io:
docker login
docker build -t <username>/<repo>:<tag> .
docker push <username>/<repo>:<tag>
```

### install helm
```sh
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
helm version
```

### install kubernetes dashboard
```sh
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```

### start kubernetes dashboard
https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard
To access dashboard, run:
```sh
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
```
NOTE: In case port-forward command does not work, make sure that kong service name is correct. Check the services in Kubernetes Dashboard namespace using:
```sh
kubectl -n kubernetes-dashboard get svc
```
Dashboard will be available at:
```sh
https://localhost:8443
```
To get login token, run:
```sh
kubectl -n kubernetes-dashboard get sa
# get service account name e.g. kubernetes-dashboard-web
kubectl -n kubernetes-dashboard create token kubernetes-dashboard-web
```

