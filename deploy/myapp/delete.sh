# 
# Remove containers from Kubernetes.
#
# Usage:
#
#   ./deploy/infra/delete.sh
#

kubectl delete -f hello-app.yaml
kubectl delete -f ingress.yaml
kubectl delete -f ns.yaml