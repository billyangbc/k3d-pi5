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
kubectl apply -f mariadb.yaml
kubectl apply -f mongo-express.yaml 
kubectl apply -f mongo.yaml 
kubectl apply -f nextcloud.yaml 
kubectl apply -f postgres.yaml 
kubectl apply -f redis.yaml 
