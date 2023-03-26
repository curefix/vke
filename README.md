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

# kubernetes dashboard 용 계정 생성
kubectl apply -f 8-account-and-binding.yaml

# kubernetes dashboard용 ingress routing
kubectl apply -f 9-ingress-for-dashboard.yaml

# admin-user 토큰 발행
kubectl -n kubernetes-dashboard create token admin-user

```

# wildcard 인증서 여러 네임스페이스에서 사용하는 방법
## reflector를 설치 함
```
helm repo add emberstack https://emberstack.github.io/helm-charts
helm repo update
helm upgrade --install reflector emberstack/reflector
```
## Certificate 설정에 reflector 설정 추가
metadata > annotations 아래 설정 추가
```
metadata:
 name: source-config-map
 annotations:
   reflector.v1.k8s.emberstack.com/reflection-allowed: "true"
   reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces: "namespace-1,namespace-2,namespace-[0-9]*"
```

# CI/CD를 위한 설정

cicd 폴더
```
# 클러스터롤 생성
kubectl apply -f 0-clusterrole.yaml

# vke용 서비스 어카운트 생성
kubectl create serviceaccount github-actions-kubernetes-vultr

kubectl create clusterrolebinding continuous-deployment \
    --clusterrole=continuous-deployment \
    --serviceaccount=default:github-actions-kubernetes-vultr
# 확인
kubectl get secret secret-github-actions-kubernetes-vultr -o yaml

# github용 토큰 생성
kubectl apply -f 1-secret-service-account.yaml
# 확인
kubectl get secret secret-github-actions-kubernetes-vultr -o yaml
# 위 명령어로 나온 출력 text를 github의 secret에 KUBERNETES_SECRET 으로 입력

# ghcr의 이미지를 읽어오기 위한 registry 계정정보 입력
kubectl create secret docker-registry github-container-registry --docker-server=ghcr.io --docker-username=<github-username> --docker-password=<token>
```

# 기타 명령

```
# 원하는 pod의 원하는 컨테이너로 명령어를 사용하고 싶을 때
kubectl exec -n shineone <POD> -c <container-name> -it /bin/bash
```

# 참고사항
## cert-manager 문제 발생
https://2kindsofcs.tistory.com/72
https://cert-manager.io/docs/configuration/acme/dns01/

## 여러 네임스페이스의 ingress를 위한 멀티 네임스페이스에 인증서를 사용할 수 있게 해주는 방법
https://github.com/emberstack/kubernetes-reflector/blob/main/README.md
https://cert-manager.io/docs/tutorials/syncing-secrets-across-namespaces/

## ci-cd 내용
https://www.vultr.com/docs/implement-a-ci-cd-pipeline-with-github-actions-and-vultr-kubernetes-engine/


