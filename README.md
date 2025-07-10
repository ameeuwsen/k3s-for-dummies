# k3s-for-dummies

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

## Deploy Portainer
kubectl apply -n portainer -f https://raw.githubusercontent.com/ameeuwsen/k3s-for-dummies/refs/heads/master/apps/portainer.yml

## Delete Portainer
kubectl delete all --all -n portainer

## Reset Leaks
kubectl delete all --all -n leaks; kubectl delete pvc leaks-a-pvc -n leaks; kubectl delete pv nas-pv-leaks
