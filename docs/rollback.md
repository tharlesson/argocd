# Guia de Rollback

## Opções rápidas de rollback

### Opção A: rollback por Git (preferida)

1. Reverta o commit que alterou a tag no overlay de destino.
2. Faça merge da PR de revert.
3. Argo CD reconcilia automaticamente (`dev`/`stage`) ou via sync manual (`prod`).

### Opção B: comando de rollback do Argo (mitigação quente)

Use somente para contenção imediata enquanto prepara o revert em Git:

```bash
argocd app rollback workloads-prod <revision-id>
```

Após estabilizar, aplique revert em Git para manter consistência da fonte da verdade.

### Opção C: abortar canary ativo

```bash
kubectl -n sample-api-prod argo rollouts abort sample-api
kubectl -n sample-api-prod argo rollouts get rollout sample-api
```

## Checklist de rollback

- aborte canary ativo se houver degradação de métricas
- reverta tag do overlay em Git
- sincronize app em prod dentro da janela, se necessário
- confirme recuperação de readiness e SLO
- registre timeline e causa raiz do incidente

