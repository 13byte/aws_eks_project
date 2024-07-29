resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_ingress_v1" "alb" {
  metadata {
    name      = "ingress-alb"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
    annotations = {
      "alb.ingress.kubernetes.io/load-balancer-name" = "ingress-alb"
      "alb.ingress.kubernetes.io/scheme"             = "internet-facing",
      "alb.ingress.kubernetes.io/target-type"        = "ip",
      # "alb.ingress.kubernetes.io/certificate-arn"    = var.acm_elb_arn

      # Health Check 관련 annotations
      "alb.ingress.kubernetes.io/healthcheck-protocol"         = "HTTP",
      "alb.ingress.kubernetes.io/healthcheck-path"             = "/api/health",
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = "15",
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds"  = "5",
      "alb.ingress.kubernetes.io/success-codes"                = "200",
      "alb.ingress.kubernetes.io/healthy-threshold-count"      = "2",
      "alb.ingress.kubernetes.io/unhealthy-threshold-count"    = "2",

      "alb.ingress.kubernetes.io/conditions.ingress-service" = jsonencode([
        {
          field = "http-header"
          httpHeaderConfig = {
            httpHeaderName = "X-Custom-Header"
            values         = ["}Y$ILp#~sY{qAA1"]
          }
        }
      ])
    }
  }
  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "ingress-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ingress-service" {
  metadata {
    name      = "ingress-service"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "spring-deploy"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "spring-deploy"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "spring-deploy"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "spring-deploy"
        }
      }

      spec {
        container {
          name  = "spring"
          image = "730335210712.dkr.ecr.ap-northeast-2.amazonaws.com/kosa-repo:goomong"

          env {
            name  = "TZ"
            value = "Asia/Seoul"
          }

          env {
            name = "DATABASE_URL"
            value_from {
              secret_key_ref {
                name = "secret"
                key  = "database-url"
              }
            }
          }

          env {
            name = "DATABASE_USERNAME"
            value_from {
              secret_key_ref {
                name = "secret"
                key  = "database-username"
              }
            }
          }

          env {
            name = "DATABASE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "secret"
                key  = "database-password"
              }
            }
          }

          env {
            name = "AdminKey"
            value_from {
              secret_key_ref {
                name = "secret"
                key  = "admin-key"
              }
            }
          }

          env {
            name = "MAIL_USERNAME"
            value_from {
              secret_key_ref {
                name = "secret"
                key  = "mail-username"
              }
            }
          }

          env {
            name = "MAIL_PASSWORD"
            value_from {
              secret_key_ref {
                name = "secret"
                key  = "mail-password"
              }
            }
          }

          env {
            name = "COS_KEY"
            value_from {
              secret_key_ref {
                name = "secret"
                key  = "cos-key"
              }
            }
          }

          resources {
            requests = {
              memory = "1Gi"
            }
          }

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}
