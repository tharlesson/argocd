variable "repositories" {
  description = "List of ECR repositories to create"
  type        = list(string)
}

variable "force_delete" {
  description = "Allow deleting non-empty repositories"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
