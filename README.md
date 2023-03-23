# vke
vke 사용 방법 정리

# 수정해야하는 내용


# vke 세팅 방법
```
# ingress설치
./0-nginx-ingress.sh

# 외부에서 dns 수정할 수 있는 환경 적용
kubectl apply -f 1-dns.yaml

# cert-manager 설치
./2-cert-manager.sh

# cert-manager for vultr webhook
git clone https://github.com/vultr/cert-manager-webhook-vultr.git

# secret 생성
kubectl create secret generic "vultr-credentials" --from-literal=apiKey=<VULTR API KEY> --namespace=cert-manager

# cert-manager for vultr webhook 설치
cd cert-manager-webhook-vultr
helm install --namespace cert-manager cert-manager-webhook-vultr ./deploy/cert-manager-webhook-vultr
cd ..

# webhook 환경 설치
kubectl apply -f 3-webhook.yaml

# 와일드카드 인증서 생성
kubectl apply -f 4-certificate.yaml

# 동작 확인용 nginx 배포
kubectl apply -f 5-nginx.yaml

# nginx용 ingress routing 생성
kubectl apply -f 6-ingress.yaml
```

# kubernetes dashboard 세팅
```
# kubernetes dashboard 설치
./7-kubernetes-dashboard.sh

# kubernetes dashboard용 ingress routing
kubectl apply -f 9-ingress-for-dashboard.yaml

# kubernetes dashboard 용 계정 생성
kubectl apply -f 8-account-and-binding.yaml

# admin-user 토큰 발행
kubectl -n kubernetes-dashboard create token admin-user

```