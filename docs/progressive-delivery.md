# Guia de Entrega Progressiva

## Estratégia padrão por ambiente

- `dev`: canary com pausas curtas e convergência rápida
- `stage`: canary com múltiplos checkpoints
- `prod`: canary conservador com gate manual e thresholds estritos

## Fluxo canary (stage/prod)

Os passos do rollout incluem:

1. aumento de peso de tráfego (`setWeight`)
2. janela de pausa
3. checagem de análise (`AnalysisTemplate`)
4. promoção para próximo passo se saudável
5. abort em caso de falha de métrica

## Gates de análise

`apps/sample-api/base/analysis-template.yaml` define métricas com Prometheus:

- taxa de sucesso (guardrail de 5xx)
- latência p95
- SLI de readiness

Os overlays por ambiente ajustam thresholds em:

- `apps/sample-api/overlays/dev/patch-analysis-template.yaml`
- `apps/sample-api/overlays/stage/patch-analysis-template.yaml`
- `apps/sample-api/overlays/prod/patch-analysis-template.yaml`

## Como trocar prod para blue/green

Opção A (recomendada): script helper

```bash
./scripts/set-rollout-strategy.sh bluegreen
# ou
make set-prod-strategy STRATEGY=bluegreen
```

O helper preserva os valores atuais de `newName` e `newTag` ao trocar a estratégia.

Opção B (manual)

```bash
cp apps/sample-api/overlays/prod/kustomization.bluegreen.yaml apps/sample-api/overlays/prod/kustomization.yaml
```

Depois faça commit e abra PR. Após merge, sincronize `workloads-prod` dentro da janela permitida.

Para voltar para canary:

```bash
./scripts/set-rollout-strategy.sh canary
# ou
make set-prod-strategy STRATEGY=canary
```

## Quando usar canary vs blue/green

Use **canary** quando:

- você precisa reduzir risco gradualmente
- validação por métricas é crítica
- aceita janelas de rollout mais longas

Use **blue/green** quando:

- você precisa de separação explícita preview/active
- quer semântica de rollback mais direta
- prefere cutover claro em vez de tráfego gradual

