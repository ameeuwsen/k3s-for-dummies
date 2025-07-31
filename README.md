# k3s-for-dummies

## Reset
curl -sfL https://raw.githubusercontent.com/ameeuwsen/k3s-for-dummies/refs/heads/master/reset.sh | sh

## Uninstall to startover
/usr/local/bin/k3s-killall.sh; /usr/local/bin/k3s-uninstall.sh; rm .kube/config;  rm -rf /etc/rancher/k3s;  rm -rf /var/lib/rancher/k3s

## Reinstall
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --disable servicelb --token R32pearlz994  --bind-address 192.168.50.200 --disable-cloud-controller
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config; kubectl get pods -A

## Helm Add MetalLb
helm repo add metallb https://metallb.github.io/metallb || helm search repo metallb
helm upgrade --install metallb metallb/metallb --create-namespace \
--namespace metallb-system --wait

## Deploy MetalLb
kubectl apply -f https://raw.githubusercontent.com/ameeuwsen/k3s-for-dummies/refs/heads/master/apps/metal.yml

## Deploy certmanager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
kubectl get pods --namespace cert-manager -w

## Deploy NGINX controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx ingress-nginx/ingress-nginx --set controller.config.strict-validate-path-type=false




## Setup TLS ingress
kubectl apply -f https://raw.githubusercontent.com/ameeuwsen/k3s-for-dummies/refs/heads/master/apps/ingress.yml

## Deploy Portainer
kubectl apply -n portainer -f https://raw.githubusercontent.com/ameeuwsen/k3s-for-dummies/refs/heads/master/apps/portainer.yml

## Delete Portainer
kubectl delete all --all -n portainer

## Reset Leaks
kubectl delete all --all -n leaks; kubectl delete pvc leaks-a-pvc -n leaks; kubectl delete pv nas-pv-leaks



### If openssl.conf not found run command below
wget https://raw.githubusercontent.com/ameeuwsen/k3s-for-dummies/refs/heads/master/misc/openssl.conf

## Setup TLS

### Install certmanager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
kubectl get pods --namespace cert-manager -w

## Create secret
kubectl create secret generic whoami-secret --from-file=tls.crt=./certs/server.crt --from-file=tls.key=./certs/server.key --namespace dev

openssl s_client -showcerts -connect ameeuwsen.com:443 < /dev/null 2> /dev/null | openssl x509 -noout -subject -issuer -ext subjectAltName
subject=CN = default-router.example.com
issuer=CN = default-router.example.com
X509v3 Subject Alternative Name: 
    DNS:*.example.com
