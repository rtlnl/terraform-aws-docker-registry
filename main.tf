resource "kubernetes_namespace" "docker_registry" {
  metadata {
    name = var.namespace
    annotations = var.namespace_annotations
  }
}

resource "kubernetes_secret" "docker_registry_secret" {
  metadata {
    name      = "docker-registry-secret"
    namespace = kubernetes_namespace.docker_registry.metadata.0.name
    labels    = var.labels
  }

  data = {
    REGISTRY_HTTP_SECRET          = var.http_secret
    REGISTRY_STORAGE_S3_ACCESSKEY = var.s3_access_key
    REGISTRY_STORAGE_S3_SECRETKEY = var.s3_secret_key
  }

  type = "Opaque"
}

resource "kubernetes_config_map" "docker_registry_config" {
  metadata {
    name      = "docker-registry-config"
    namespace = kubernetes_namespace.docker_registry.metadata.0.name
    labels    = var.labels
  }

  data = {
    "config.yml"                 = "${file("${path.module}/templates/config.yml")}"
    "REGISTRY_STORAGE_S3_REGION" = var.s3_region
    "REGISTRY_STORAGE_S3_BUCKET" = var.s3_bucket
    "SEARCH_BACKEND"             = "sqlalchemy"
  }
}

resource "kubernetes_service" "docker_registry" {
  metadata {
    name      = "docker-registry"
    namespace = kubernetes_namespace.docker_registry.metadata.0.name
    labels    = var.labels
  }

  spec {
    port {
      name        = "registry"
      protocol    = "TCP"
      port        = var.service_port
      target_port = "5000"
    }

    selector = {
      app = "docker-registry"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "docker_registry" {
  metadata {
    name      = "docker-registry"
    namespace = kubernetes_namespace.docker_registry.metadata.0.name
    labels    = var.labels
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "docker-registry"
      }
    }

    template {
      metadata {
        labels = {
          app = "docker-registry"
        }
      }

      spec {
        volume {
          name = kubernetes_config_map.docker_registry_config.metadata.0.name

          config_map {
            name = kubernetes_config_map.docker_registry_config.metadata.0.name
          }
        }

        container {
          name    = "docker-registry"
          image   = "registry:${var.image_version}"
          command = ["/bin/registry", "serve", "/etc/docker/registry/config.yml"]

          port {
            container_port = 5000
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.docker_registry_secret.metadata.0.name
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.docker_registry_config.metadata.0.name
            }
          }



          volume_mount {
            name       = kubernetes_config_map.docker_registry_config.metadata.0.name
            mount_path = "/etc/docker/registry"
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "5000"
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "5000"
            }
          }

          image_pull_policy = "IfNotPresent"
        }

        security_context {
          run_as_user = 1000
          fs_group    = 1000
        }
      }
    }

    min_ready_seconds = 5
  }
}

resource "kubernetes_ingress" "docker_registry" {
  metadata {
    name        = "docker-registry"
    namespace   = kubernetes_namespace.docker_registry.metadata.0.name
    annotations = var.ingress_annotations
  }

  spec {
    rule {
      host = var.ingress_dns

      http {
        path {
          backend {
            service_name = "docker-registry"
            service_port = var.service_port
          }
        }
      }
    }
  }
}

