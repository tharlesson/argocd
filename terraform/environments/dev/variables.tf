variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "gitops-dev"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.31"
}

variable "domain_name" {
  description = "Base domain name (e.g. platform.example.com)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.large"]
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 6
}

variable "node_desired_size" {
  type    = number
  default = 3
}

variable "gitops_repo_url" {
  description = "GitOps repo URL"
  type        = string
}

variable "gitops_repo_revision" {
  description = "GitOps target revision"
  type        = string
  default     = "main"
}

variable "gitops_root_path" {
  description = "Path for root app"
  type        = string
  default     = "argocd/root-app"
}

variable "ecr_repositories" {
  description = "ECR repository names"
  type        = list(string)
  default     = ["sample-api"]
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
