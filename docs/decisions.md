# Decisões Arquiteturais e Trade-offs

## 1) App of Apps em vez de ApplicationSet

Decisão:

- App of Apps é o modelo de controle padrão para fronteiras de ambiente determinísticas.

Trade-off:

- Mais manifests estáticos do que uma matriz gerada dinamicamente.
- Melhor legibilidade para auditoria e responsabilidade.

## 2) ALB controller em vez de NGINX ingress

Decisão:

- Usar AWS Load Balancer Controller para ingress.

Trade-off:

- Integração nativa com AWS e melhor suporte ao traffic routing do Argo Rollouts.
- Menor portabilidade entre clouds em comparação ao NGINX.

## 3) Terraform instala addons de bootstrap

Decisão:

- Terraform instala baseline mínimo operacional de addons e semeia a root app do Argo CD.

Trade-off:

- Provisionamento inicial mais rápido.
- Estado desejado de day-1+ continua reconciliado por Git via Argo CD.

## 4) Canary por padrão, blue/green opcional em prod

Decisão:

- Canary é padrão para reduzir blast radius gradualmente.
- Blue/green fica disponível para cenários de cutover explícito.

Trade-off:

- Canary oferece controle de risco mais rico com rollout mais longo.
- Blue/green simplifica modelo mental e rollback por troca de serviço.

## 5) Segredo de notifications externalizado

Decisão:

- Token de notifications do Argo CD é obtido do AWS Secrets Manager via ExternalSecret.

Trade-off:

- Dependência adicional de ESO e configuração do secret-store.
- Elimina credenciais estáticas de notificação no Git.

