#!/bin/sh

/usr/local/bin/k3s-killall.sh; /usr/local/bin/k3s-uninstall.sh; rm .kube/config;  rm -rf /etc/rancher/k3s;  rm -rf /var/lib/rancher/k3s

curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --disable servicelb --token R32pearlz994  --bind-address 192.168.50.200 --disable-cloud-controller --disable traefik
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config; kubectl get pods -A

helm upgrade --install metallb metallb/metallb --create-namespace --namespace metallb-system --wait
kubectl apply -f https://raw.githubusercontent.com/ameeuwsen/k3s-for-dummies/refs/heads/master/apps/metal.yml

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
kubectl get pods --namespace cert-manager

helm install nginx ingress-nginx/ingress-nginx --set controller.config.strict-validate-path-type=false

kubectl apply -n portainer -f https://raw.githubusercontent.com/ameeuwsen/k3s-for-dummies/refs/heads/master/apps/portainer.yml
