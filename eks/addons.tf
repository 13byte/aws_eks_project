resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks_cluster.name

  addon_name    = "coredns"
  addon_version = var.coredns_version

  depends_on = [
    aws_eks_node_group.eks_node_group,
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = "kube-proxy"
  addon_version = var.kube_proxy_version

  depends_on = [
    aws_eks_node_group.eks_node_group,
  ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks_cluster.name

  addon_name    = "vpc-cni"
  addon_version = var.vpc_cni_version

  depends_on = [
    aws_eks_node_group.eks_node_group,
  ]
}

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name = aws_eks_cluster.eks_cluster.name

  addon_name    = "aws-ebs-csi-driver"
  addon_version = var.ebs_csi_driver_version

  depends_on = [
    aws_eks_node_group.eks_node_group,
  ]
}
