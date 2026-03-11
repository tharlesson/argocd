# Habilitação de OIDC / SSO no Argo CD

Scaffold de OIDC já está preparado em:

- `platform/argocd/base/argocd-cm.yaml`
- `platform/argocd/base/argocd-rbac-cm.yaml`

## Passos para habilitar

1. Crie a aplicação/cliente OIDC no seu IdP.
2. Configure a redirect URI para o Argo CD.
3. Defina o segredo de cliente OIDC no `argocd-secret` (chave `oidc.clientSecret`).
4. Substitua issuer/client ID placeholders em `argocd-cm`.
5. Mapeie grupos do IdP para papéis no `argocd-rbac-cm` e nas roles de AppProject.

## Baseline atual de mapeamento de papéis

- `engineering:platform:admins` -> `role:platform-admin`
- `engineering:all` -> `role:readonly`
- grupos de projeto:
  - `engineering:dev:readonly`
  - `engineering:stage:ops`
  - `engineering:prod:release-managers`

