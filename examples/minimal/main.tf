resource "aws_s3_bucket" "docker_registry_bucket" {
  bucket = "docker-registry"
  acl    = "private"
  region = "eu-west-1"
}

module "docker-registry" {
  source = "github.com/rtlnl/terraform-aws-docker-registry"
  version = "1.0.0"

  http_secret            = "randomlygeneratedstring"
  s3_access_key          = "<s3_access_key>"
  s3_secret_key          = "<s3_secret_key"
  s3_bucket              = aws_s3_bucket.docker_registry_bucket.id
  s3_region              = aws_s3_bucket.docker_registry_bucket.region
  ingress_dns            = "http://yourdns.example.com"
  ingress_annotations    = {
      "kubernetes.io/ingress.class":"nginx" #if you use nginx as your ingress controller for example
  }
}