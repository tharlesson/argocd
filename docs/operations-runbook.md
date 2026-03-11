# Guia Operacional

## Checagens diárias

- `argocd app list` e inspeção de estados `OutOfSync`/`Degraded`
- fases de rollout saudáveis em todos os ambientes
- status dos alertas no Prometheus
- status de sincronização dos ExternalSecrets

## Operações comuns

### Disparar sync manual em prod

```bash
argocd app sync workloads-prod
```

### Aprovar canary pausado em prod

```bash
kubectl -n sample-api-prod argo rollouts promote sample-api
```

### Abortar canary

```bash
kubectl -n sample-api-prod argo rollouts abort sample-api
```

### Ver detalhes do rollout

```bash
kubectl -n sample-api-prod argo rollouts get rollout sample-api
kubectl -n sample-api-prod get analysisrun
kubectl -n sample-api-prod describe analysisrun <name>
```

### Trocar estratégia de prod para blue/green

```bash
./scripts/set-rollout-strategy.sh bluegreen
```

Faça commit e merge da mudança, depois sincronize `workloads-prod` na janela permitida.

## Atalhos de resposta a alertas

- `RolloutAborted`: inspecione o resultado do AnalysisRun e compare métricas com a revisão estável anterior.
- `SampleApiUnavailable`: valide pods, probes, seletores de service e saúde dos targets do ingress.
- `SampleApiHighErrorRate`: confirme tag recém-promovida e faça rollback se necessário.
- `SampleApiHighP95Latency`: investigue saturação de CPU/memória e saúde de dependências.

## Pontos de ajuste de SLO

Ajuste thresholds em:

- `apps/sample-api/overlays/*/patch-analysis-template.yaml`
- `platform/monitoring/base/prometheusrule-sample-api.yaml`


