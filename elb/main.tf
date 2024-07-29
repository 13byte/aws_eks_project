data "aws_lb" "alb" {
  tags = {
    "elbv2.k8s.aws/cluster"    = "kosa"
    "ingress.k8s.aws/resource" = "LoadBalancer"
    "ingress.k8s.aws/stack"    = "spring-boot/ingress-alb"
  }
}
