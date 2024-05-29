# Install k3d on raspberry pi 5

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
k3d cluster create testcluster

```

## Delete k3d cluster

```sh
k3d cluster delete testcluster
```

## Using ansible to install k3d

```sh
ansible-playbook -i hosts playbook.yml --ask-pass --ask-become-pass
```

## Run ansible with passwordless authentication

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