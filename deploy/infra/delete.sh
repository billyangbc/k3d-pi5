# 
# Remove containers from Kubernetes.
#
# Usage:
#
#   ./deploy/infra/delete.sh
#

kubectl delete -f mariadb.yaml
kubectl delete -f mongo-express.yaml 
kubectl delete -f mongo.yaml 
kubectl delete -f nextcloud.yaml 
kubectl delete -f postgres.yaml 
kubectl delete -f redis.yaml

kubectl delete -f hello-app.yaml
kubectl delete -f ingress.yaml

kubectl delete -f ns.yaml