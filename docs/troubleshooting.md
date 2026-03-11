# Solucao de Problemas

## Root app não sincroniza

- confirme URL e revisão do repositório em `argocd/root-app/gitops-settings.yaml`
- verifique credenciais de repositório no Argo CD
- valide se AppProjects existem e permitem namespace de destino

## workloads-prod não sincroniza

- confirme se o horário atual está dentro da sync window do AppProject
- valide se o operador possui permissões de `prod-approver`
- execute sync manual: `argocd app sync workloads-prod`

## Rollout travado em pause

- esperado para pause manual no canary de prod
- promova manualmente:
  - `kubectl -n sample-api-prod argo rollouts promote sample-api`

## Analysis falhando de forma inesperada

- execute a query no Prometheus manualmente
- confirme labels de métricas com `app="sample-api"`
- valide seleção do ServiceMonitor e saúde dos targets

## ExternalSecret não materializa

- verifique logs do controlador ESO
- confirme existência do segredo no AWS Secrets Manager
- valide trust policy e permissões do IRSA

## ALB ingress não roteia

- verifique logs do AWS Load Balancer Controller
- confirme tags de subnet para ELB/internal ELB
- garanta que a ingress class é `alb`


