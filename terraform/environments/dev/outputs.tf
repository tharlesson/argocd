output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "argocd_url" {
  value = "https://argocd.${var.domain_name}"
}

output "external_secrets_irsa_role" {
  value = module.addons.external_secrets_role_arn
}

output "aws_lb_controller_irsa_role" {
  value = module.addons.aws_load_balancer_controller_role_arn
}
