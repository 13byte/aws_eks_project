output "id" {
  value = data.aws_lb.alb.id
}

output "arn" {
  value = data.aws_lb.alb.arn
}

output "dns_name" {
  value = data.aws_lb.alb.dns_name
}
