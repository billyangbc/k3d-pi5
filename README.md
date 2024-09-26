
## Merge kube config into local kube config file
Once the ansible playbook is done, there should be a file with name `k3d-kube-config` in the folder where ansible playbook runs.
Merge the content into local kube config (~/.kube/config),then use command to check:

```sh

kubectl get nodes
```

## Using ansible to install k3d

```sh
ansible-playbook -i hosts playbook.yml --ask-pass --ask-become-pass
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

