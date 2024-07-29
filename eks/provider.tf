locals {
  api_version = "client.authentication.k8s.io/v1"
  args        = ["eks", "get-token", "--cluster-name", var.cluster_name, "--profile", var.aws_profile]
  command     = "aws"
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)

  exec {
    api_version = local.api_version
    args        = local.args
    command     = local.command
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    exec {
      api_version = local.api_version
      args        = local.args
      command     = local.command
    }
  }
}
