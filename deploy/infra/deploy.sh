#
# Deploys all microservices to a Kubernetes instance.
#
# Usage:
#
#   ./deploy/infra/deploy.sh
#
# 
# Deploy containers to Kubernetes.
#
# Don't forget to change kubectl to your production Kubernetes instance
#
# export KUBECONFIG=~/.kube/config-pi5
# export KUBECONFIG=~/.kube/config-ai
kubectl apply -f ns.yaml
kubectl apply -f mariadb.yaml
kubectl apply -f mongo-express.yaml 
kubectl apply -f mongo.yaml 
kubectl apply -f nextcloud.yaml 
kubectl apply -f postgres.yaml 
kubectl apply -f redis.yaml

kubectl apply -f hello-app.yaml
kubectl apply -f ingress.yaml