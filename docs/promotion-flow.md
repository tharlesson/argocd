# Fluxo de Promoção (somente Git)

## Princípios

- CI nunca executa `kubectl apply` para deploy de aplicação.
- Promoção é uma mudança em Git no overlay do ambiente de destino.
- Argo CD reconcilia mudanças do Git após merge.

## Release em dev

1. Faça merge do código da aplicação em `main`.
2. Workflow `Build Image and Update Dev Overlay`:
   - build da imagem e push para ECR
   - update de `apps/sample-api/overlays/dev/kustomization.yaml` com nova tag
   - commit da atualização no Git
3. Argo CD faz auto-sync de `workloads-dev`.

## Promoção para stage

Execute o workflow `Promote Image Between Environments` com:

- `source_env=dev`
- `target_env=stage`

O workflow abre PR com bump de tag em stage.
Após merge, Argo CD faz auto-sync em stage.

## Promoção para prod

Execute o workflow com:

- `source_env=stage`
- `target_env=prod`

O workflow abre PR com bump de tag em prod.

Controles de produção:

- proteção de GitHub Environment pode exigir aprovação antes de executar workflow
- `workloads-prod` no Argo CD permanece com sync manual
- sync window do AppProject restringe sync ao horário comercial em `America/Sao_Paulo`

## Checklist de verificação após cada promoção

- status da aplicação no Argo em `Healthy/Synced`
- rollout avançou os passos esperados
- nenhum alerta ativo de erro/latência
- dashboards estáveis
- smoke test opcional concluído

