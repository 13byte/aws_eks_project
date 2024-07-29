locals {
  openid_connect_provider_id  = aws_iam_openid_connect_provider.eks.arn
  openid_connect_provider_url = replace(aws_iam_openid_connect_provider.eks.url, "https://", "")
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["55635CFEA6A15F4770CC5EC0977492B318F9B0CC"]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}
