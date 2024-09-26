# Install k3d on raspberry pi 5 (arm64)

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

## get kubeconfig

```sh
k3d kubeconfig get --all >> k3d_cluster.kubeconfig
```

## Merge kube config into local kube config file
Once get the kubeconfig, merge the content into local kube config (~/.kube/config),then use command to check:

```sh
kubectl get nodes
```

## Delete k3d cluster

```sh
k3d cluster delete k3d-cluster
```
