
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

# references:
https://www.microcharon.com/tech/368.html
https://eliu.github.io/2021/03/25/run-local-k8s-using-k3d/
https://www.cnblogs.com/haogj/p/16397876.html
https://cloud.tencent.com/developer/article/1963647
https://wiki.zguishen.com/Kubernetes/k3d/
http://liuyang1.com/blog/44

  k3d is based on k3s and deploys the traefik ingress controller by default along with a basic load balancer implementation.
  A nice trick i use all the time is to create a cluster that forwards your local ports 80 and 443 to the load balancer in front of traefik. That way you can create ingresses that point to localhost or *.localhost and it will just work.


docker run -t -d -p 9980:9980 -e "extra_params=--o:ssl.enable=false" collabora/code
docker run -p 0.0.0.0:9980:9980 -e "domain=pi5\\.dev\\.local" --cap-add MKNOD collabora/code


docker run -p 9980:9980 -e "extra_params=--o:ssl.enable=false" -e "domain=nextcloud\\.local" --cap-add MKNOD collabora/code

in docker `/etc/coolwsd/coolwsd.xml`,  add
```
<host desc="Regex pattern of hostname to allow or deny." allow="true">127\.0\.0\.1</host>
<host desc="Regex pattern of hostname to allow or deny." allow="true">owncloud\.myserver\.com</host>
```
echo '<host desc="Regex pattern of hostname to allow or deny." allow="true">nextcloud.local</host>' >> /etc/coolwsd/coolwsd.xml


docker run -p 9980:9980 -e "extra_params=--o:ssl.enable=false" -e 'domain=192.168.100.205' --cap-add MKNOD collabora/code


## Quick Tryout Nextcloud Docker
https://www.collaboraonline.com/quick-tryout-nextcloud-docker/
You can try CODE in 5 minutes with Nextcloud following these basic steps:

    Find out the IP address of your computer, e.g. 192.168.100.20
    Run Nextcloud from docker:
    docker run -d -p 80:80 nextcloud
    In your browser go to http://192.168.100.20 and set up your Nextcloud.
    In Nextcloud go to Apps – Office and Text, and install Nextcloud Office (Collabora Online) app.
    Run CODE from docker:
    docker run -t -d -p 9980:9980 -e "extra_params=--o:ssl.enable=false" collabora/code
    Set up the Collabora Online server in Nextcloud Settings – Collabora Online to http://192.168.100.20:9980

Note 1: Of course, this is only good for a quick look at the features, it is not for production by any means.

Note 2: Do not use localhost or 127.0.0.1 instead of IP address of your computer, because these addresses do not resolve from the containers. This means not only not using it for the address of Collabora Online configured in Nextcloud, but also for the URL you connect to in the browser to test.
