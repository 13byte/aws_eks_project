data "external" "iam_user_arns" {
  program = ["python", "${path.module}/scripts/get_iam_users.py", var.iam_group_name, var.aws_profile]
}

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [aws_eks_cluster.eks_cluster]

  metadata {
    namespace = "kube-system"
    name      = "aws-auth"
  }

  data = {
    mapRoles = yamlencode([{
      rolearn  = aws_iam_role.eks_node_group.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }])
    mapUsers = yamlencode(
      concat(
        length(jsondecode(data.external.iam_user_arns.result.user_arns)) > 0 ?
        flatten(
          [for user in jsondecode(data.external.iam_user_arns.result.user_arns) :
            {
              userarn  = user
              username = split("/", user)[1]
              groups   = ["system:masters"]
            }
          ]
        ) : []
      )
    )
  }
}
