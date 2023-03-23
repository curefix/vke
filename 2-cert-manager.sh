# kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.yaml

# dns 서버를 바꾸지 않으면 예전 ip로 동작해서 문제가 생기기 때문에 수정 함
helm repo add jetstack https://charts.jetstack.io

helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.11.0 \
  --set installCRDs=true \
  --set 'extraArgs={--dns01-recursive-nameservers-only,--dns01-recursive-nameservers=8.8.8.8:53,1.1.1.1:53}'