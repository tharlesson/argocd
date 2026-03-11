output "external_secrets_role_arn" {
  value = aws_iam_role.external_secrets.arn
}

output "aws_load_balancer_controller_role_arn" {
  value = aws_iam_role.aws_load_balancer_controller.arn
}

output "argocd_namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
}
