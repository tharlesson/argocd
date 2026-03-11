module "addons" {
  source = "../../modules/addons"

  cluster_name           = module.eks.cluster_name
  cluster_endpoint       = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_certificate_authority_data
  oidc_provider_arn      = module.eks.cluster_oidc_provider_arn
  oidc_provider_url      = module.eks.cluster_oidc_provider
  region                 = var.region
  vpc_id                 = module.vpc.vpc_id
  domain_name            = var.domain_name

  gitops_repo_url      = var.gitops_repo_url
  gitops_repo_revision = var.gitops_repo_revision
  gitops_root_path     = var.gitops_root_path

  tags = local.common_tags

  depends_on = [module.eks]
}
