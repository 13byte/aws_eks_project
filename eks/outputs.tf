output "cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}

output "cluster_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_default_security_group_id" {
  value = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

output "cluster_security_group_id" {
  value = aws_security_group.eks_cluster.id
}

output "aws_auth_config_map" {
  value = kubernetes_config_map.aws_auth.data
}

output "coredns_version" {
  value = aws_eks_addon.coredns.addon_version
}

output "kube_proxy_version" {
  value = aws_eks_addon.kube_proxy.addon_version
}

output "vpc_cni_version" {
  value = aws_eks_addon.vpc_cni.addon_version
}

output "ebs_csi_driver_version" {
  value = aws_eks_addon.aws_ebs_csi_driver.addon_version
}
