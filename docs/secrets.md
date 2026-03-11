# Gerenciamento de Segredos

Esta plataforma usa External Secrets Operator com AWS Secrets Manager.

## Secret store de cluster

- `platform/external-secrets/base/cluster-secret-store.yaml`
- autenticação via IRSA na service account `external-secrets`

## Fluxo de segredos da aplicação

- `apps/sample-api/base/externalsecret.yaml`
- nome da chave por ambiente é ajustado nos overlays
- Kubernetes Secret é criado em runtime como `sample-api-secrets`

## Fluxo de segredo de notifications do Argo CD

- `platform/argocd/base/argocd-notifications-externalsecret.yaml`
- Secret alvo no Kubernetes: `argocd-notifications-secret`
- chave no AWS Secrets Manager:
  - `/gitops/argocd/notifications` com property `SLACK_TOKEN`

## Chaves obrigatórias no AWS Secrets Manager

- `/gitops/sample-api/dev` -> `API_KEY`
- `/gitops/sample-api/stage` -> `API_KEY`
- `/gitops/sample-api/prod` -> `API_KEY`
- `/gitops/argocd/notifications` -> `SLACK_TOKEN`

## Notas de segurança

- nenhum valor de segredo da aplicação é commitado no Git
- rotação de segredo é feita no AWS Secrets Manager
- ESO atualiza os Kubernetes Secrets de acordo com o refresh interval
- política IAM do External Secrets concede apenas leitura de Secrets Manager/KMS decrypt

