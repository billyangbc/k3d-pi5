
# Kubernetes Tips

## 1. Install helm

```sh
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
helm version
```

## 2. Install kubernetes dashboard [kuebets-dashboard](https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard)

```sh
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```

## 3. Start kubernetes dashboard

To access dashboard, run:

```sh
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
```

NOTE: In case port-forward command does not work, make sure that kong service name is correct. Check the services in Kubernetes Dashboard namespace using:

```sh
kubectl -n kubernetes-dashboard get svc
```

Dashboard will be available at `https://localhost:8443`


## 4. Get login token for dashboard
To get login token for dashboard, run:

```sh
kubectl -n kubernetes-dashboard get sa
# get service account name e.g. kubernetes-dashboard-web
kubectl -n kubernetes-dashboard create token kubernetes-dashboard-web
```