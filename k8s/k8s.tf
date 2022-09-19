resource "kubernetes_deployment" "cartservice" {
  metadata {
    name = "cartservice"
  }

  spec {
    selector {
      match_labels = {
        app = "cartservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "cartservice"
        }
      }

      spec {
        container {
          name  = "server"
          image = "9870050478/cartservice:v1"

          port {
            container_port = 7070
          }

          env {
            name  = "REDIS_ADDR"
            value = "redis-cart:6379"
          }

          env {
            name  = "SERVICE_NAME"
            value = "cart"
          }

          resources {
            limits = {
              cpu = "300m"

              memory = "128Mi"
            }

            requests = {
              cpu = "200m"

              memory = "64Mi"
            }
          }
        }

        termination_grace_period_seconds = 5
        service_account_name             = "default"
      }
    }
  }
}

resource "kubernetes_service" "cartservice" {
  metadata {
    name = "cartservice"
  }

  spec {
    port {
      name        = "grpc"
      port        = 7070
      target_port = "7070"
    }

    selector = {
      app = "cartservice"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "currencyservice" {
  metadata {
    name = "currencyservice"
  }

  spec {
    selector {
      match_labels = {
        app = "currencyservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "currencyservice"
        }
      }

      spec {
        container {
          name  = "server"
          image = "9870050478/currencyservice:v1"

          port {
            name           = "grpc"
            container_port = 7000
          }

          env {
            name  = "PORT"
            value = "7000"
          }

          env {
            name  = "SERVICE_NAME"
            value = "currency"
          }

          resources {
            limits = {
              cpu = "200m"

              memory = "128Mi"
            }

            requests = {
              cpu = "100m"

              memory = "64Mi"
            }
          }
        }

        termination_grace_period_seconds = 5
        service_account_name             = "default"
      }
    }
  }
}

resource "kubernetes_service" "currencyservice" {
  metadata {
    name = "currencyservice"
  }

  spec {
    port {
      name        = "grpc"
      port        = 7000
      target_port = "7000"
    }

    selector = {
      app = "currencyservice"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "adservice" {
  metadata {
    name = "adservice"
  }

  spec {
    selector {
      match_labels = {
        app = "adservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "adservice"
        }
      }

      spec {
        container {
          name  = "server"
          image = "9870050478/adservice:v1"

          port {
            container_port = 9555
          }

          env {
            name  = "PORT"
            value = "9555"
          }

          resources {
            limits = {
              cpu = "500m"

              memory = "300Mi"
            }

            requests = {
              cpu = "250m"

              memory = "180Mi"
            }
          }
        }

        termination_grace_period_seconds = 5
        service_account_name             = "default"
      }
    }
  }
}

resource "kubernetes_service" "adservice" {
  metadata {
    name = "adservice"
  }

  spec {
    port {
      name        = "grpc"
      port        = 9555
      target_port = "9555"
    }

    selector = {
      app = "adservice"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "checkoutservice" {
  metadata {
    name = "checkoutservice"
  }

  spec {
    selector {
      match_labels = {
        app = "checkoutservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "checkoutservice"
        }
      }

      spec {
        container {
          name  = "server"
          image = "9870050478/checkoutservice:v1"

          port {
            container_port = 5050
          }

          env {
            name  = "PORT"
            value = "5050"
          }

          env {
            name  = "PRODUCT_CATALOG_SERVICE_ADDR"
            value = "productcatalogservice:3550"
          }

          env {
            name  = "SHIPPING_SERVICE_ADDR"
            value = "shippingservice:50051"
          }

          env {
            name  = "PAYMENT_SERVICE_ADDR"
            value = "paymentservice:50051"
          }

          env {
            name  = "EMAIL_SERVICE_ADDR"
            value = "emailservice:5000"
          }

          env {
            name  = "CURRENCY_SERVICE_ADDR"
            value = "currencyservice:7000"
          }

          env {
            name  = "CART_SERVICE_ADDR"
            value = "cartservice:7070"
          }

          env {
            name  = "CACHE_USER_THRESHOLD"
            value = "35000"
          }

          resources {
            limits = {
              cpu = "200m"

              memory = "32Mi"
            }

            requests = {
              cpu = "100m"

              memory = "32Mi"
            }
          }
        }

        service_account_name = "default"
      }
    }
  }
}

resource "kubernetes_service" "checkoutservice" {
  metadata {
    name = "checkoutservice"
  }

  spec {
    port {
      name        = "grpc"
      port        = 5050
      target_port = "5050"
    }

    selector = {
      app = "checkoutservice"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "productcatalogservice" {
  metadata {
    name = "productcatalogservice"
  }

  spec {
    selector {
      match_labels = {
        app = "productcatalogservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "productcatalogservice"
        }
      }

      spec {
        container {
          name  = "server"
          image = "9870050478/productcatalogservice:v1"

          port {
            container_port = 3550
          }

          env {
            name  = "PORT"
            value = "3550"
          }

          resources {
            limits = {
              cpu = "200m"

              memory = "128Mi"
            }

            requests = {
              cpu = "100m"

              memory = "64Mi"
            }
          }
        }

        termination_grace_period_seconds = 5
        service_account_name             = "default"
      }
    }
  }
}

resource "kubernetes_service" "productcatalogservice" {
  metadata {
    name = "productcatalogservice"
  }

  spec {
    port {
      name        = "grpc"
      port        = 3550
      target_port = "3550"
    }

    selector = {
      app = "productcatalogservice"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "emailservice" {
  metadata {
    name = "emailservice"
  }

  spec {
    selector {
      match_labels = {
        app = "emailservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "emailservice"
        }
      }

      spec {
        container {
          name  = "server"
          image = "9870050478/emailservice:v1"

          port {
            container_port = 8080
          }

          env {
            name  = "PORT"
            value = "8080"
          }

          env {
            name  = "SERVICE_NAME"
            value = "email"
          }

          resources {
            limits = {
              cpu = "200m"

              memory = "128Mi"
            }

            requests = {
              cpu = "100m"

              memory = "64Mi"
            }
          }
        }

        termination_grace_period_seconds = 5
        service_account_name             = "default"
      }
    }
  }
}

resource "kubernetes_service" "emailservice" {
  metadata {
    name = "emailservice"
  }

  spec {
    port {
      name        = "grpc"
      port        = 5000
      target_port = "8080"
    }

    selector = {
      app = "emailservice"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "redis_cart" {
  metadata {
    name = "redis-cart"
  }

  spec {
    selector {
      match_labels = {
        app = "redis-cart"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis-cart"
        }
      }

      spec {
        volume {
          name = "redis-data"
        }

        container {
          name  = "redis"
          image = "redis:alpine"

          port {
            container_port = 6379
          }

          resources {
            limits = {
              cpu = "125m"

              memory = "256Mi"
            }

            requests = {
              cpu = "70m"

              memory = "200Mi"
            }
          }

          volume_mount {
            name       = "redis-data"
            mount_path = "/data"
          }

          liveness_probe {
            tcp_socket {
              port = "6379"
            }

            period_seconds = 5
          }

          readiness_probe {
            tcp_socket {
              port = "6379"
            }

            period_seconds = 5
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "redis_cart" {
  metadata {
    name = "redis-cart"
  }

  spec {
    port {
      name        = "redis"
      port        = 6379
      target_port = "6379"
    }

    selector = {
      app = "redis-cart"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "recommendationservice" {
  metadata {
    name = "recommendationservice"
  }

  spec {
    selector {
      match_labels = {
        app = "recommendationservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "recommendationservice"
        }
      }

      spec {
        container {
          name  = "server"
          image = "9870050478/recommendationservice:v1"

          port {
            container_port = 8080
          }

          env {
            name  = "PORT"
            value = "8080"
          }

          env {
            name  = "PRODUCT_CATALOG_SERVICE_ADDR"
            value = "productcatalogservice:3550"
          }

          env {
            name  = "SERVICE_NAME"
            value = "recommendation"
          }

          resources {
            limits = {
              cpu = "200m"

              memory = "450Mi"
            }

            requests = {
              cpu = "100m"

              memory = "220Mi"
            }
          }
        }

        termination_grace_period_seconds = 5
        service_account_name             = "default"
      }
    }
  }
}

resource "kubernetes_service" "recommendationservice" {
  metadata {
    name = "recommendationservice"
  }

  spec {
    port {
      name        = "grpc"
      port        = 8080
      target_port = "8080"
    }

    selector = {
      app = "recommendationservice"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "paymentservice" {
  metadata {
    name = "paymentservice"
  }

  spec {
    selector {
      match_labels = {
        app = "paymentservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "paymentservice"
        }
      }

      spec {
        container {
          name  = "server"
          image = "9870050478/paymentservice:v1"

          port {
            container_port = 50051
          }

          env {
            name  = "PORT"
            value = "50051"
          }

          env {
            name  = "SERVICE_NAME"
            value = "payment"
          }

          resources {
            limits = {
              cpu = "200m"

              memory = "128Mi"
            }

            requests = {
              cpu = "100m"

              memory = "64Mi"
            }
          }
        }

        termination_grace_period_seconds = 5
        service_account_name             = "default"
      }
    }
  }
}

resource "kubernetes_service" "paymentservice" {
  metadata {
    name = "paymentservice"
  }

  spec {
    port {
      name        = "grpc"
      port        = 50051
      target_port = "50051"
    }

    selector = {
      app = "paymentservice"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "shippingservice" {
  metadata {
    name = "shippingservice"
  }

  spec {
    selector {
      match_labels = {
        app = "shippingservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "shippingservice"
        }
      }

      spec {
        container {
          name  = "server"
          image = "9870050478/shippingservice:v1"

          port {
            container_port = 50051
          }

          env {
            name  = "PORT"
            value = "50051"
          }

          resources {
            limits = {
              cpu = "200m"

              memory = "128Mi"
            }

            requests = {
              cpu = "100m"

              memory = "64Mi"
            }
          }
        }

        service_account_name = "default"
      }
    }
  }
}

resource "kubernetes_service" "shippingservice" {
  metadata {
    name = "shippingservice"
  }

  spec {
    port {
      name        = "grpc"
      port        = 50051
      target_port = "50051"
    }

    selector = {
      app = "shippingservice"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "loadgenerator" {
  metadata {
    name = "loadgenerator"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "loadgenerator"
      }
    }

    template {
      metadata {
        labels = {
          app = "loadgenerator"
        }

        annotations = {
          "sidecar.istio.io/rewriteAppHTTPProbers" = "true"
        }
      }

      spec {
        container {
          name  = "main"
          image = "9870050478/loadgenerator:v1"

          env {
            name  = "FRONTEND_ADDR"
            value = "http://frontend"
          }

          env {
            name  = "USERS"
            value = "5"
          }

          resources {
            limits = {
              cpu = "500m"

              memory = "512Mi"
            }

            requests = {
              cpu = "300m"

              memory = "256Mi"
            }
          }
        }

        restart_policy                   = "Always"
        termination_grace_period_seconds = 5
        service_account_name             = "default"
      }
    }
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
  }

  spec {
    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }

        annotations = {
          "sidecar.istio.io/rewriteAppHTTPProbers" = "true"
        }
      }

      spec {
        container {
          name  = "server"
          image = "9870050478/frontend:v2"

          port {
            container_port = 8080
          }

          env {
            name  = "PORT"
            value = "8080"
          }

          env {
            name  = "PRODUCT_CATALOG_SERVICE_ADDR"
            value = "productcatalogservice:3550"
          }

          env {
            name  = "CURRENCY_SERVICE_ADDR"
            value = "currencyservice:7000"
          }

          env {
            name  = "CART_SERVICE_ADDR"
            value = "cartservice:7070"
          }

          env {
            name  = "RECOMMENDATION_SERVICE_ADDR"
            value = "recommendationservice:8080"
          }

          env {
            name  = "SHIPPING_SERVICE_ADDR"
            value = "shippingservice:50051"
          }

          env {
            name  = "CHECKOUT_SERVICE_ADDR"
            value = "checkoutservice:5050"
          }

          env {
            name  = "AD_SERVICE_ADDR"
            value = "adservice:9555"
          }

          env {
            name  = "ENV_PLATFORM"
            value = "aws"
          }

          resources {
            limits = {
              cpu = "200m"

              memory = "128Mi"
            }

            requests = {
              cpu = "100m"

              memory = "64Mi"
            }
          }
        }

        service_account_name = "default"
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend"
  }

  spec {
    port {
      name        = "http"
      port        = 80
      target_port = "8080"
    }

    selector = {
      app = "frontend"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "frontend_external" {
  metadata {
    name = "frontend-external"
  }

  spec {
    port {
      name        = "http"
      port        = 80
      target_port = "8080"
    }

    selector = {
      app = "frontend"
    }

    type = "LoadBalancer"
  }
}

output "k8s_load_balancer_hostname" {
  value = kubernetes_service.frontend_external.status.0.load_balancer.0.ingress.0.hostname
}
