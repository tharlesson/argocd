# Bootstrap do Argo CD

Terraform instala o Argo CD e aplica a `root-app` inicial.

Após o bootstrap, a `root-app` passa a ser reconciliada pelo próprio Git (`argocd/root-app/root-application.yaml`), então o Argo CD gerencia os próprios manifests de controle.

Fallback manual (se necessário):

```bash
kubectl apply -f root-application.yaml
```

