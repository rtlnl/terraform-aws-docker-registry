# Private Docker Registry

This repo contains a terraform module to deploy a privately managed docker registry in your AWS EKS Kubernetes cluster. The images will be stored on s3.

## Usage

Include the following in your `main.tf` file to include the private docker registry in your infrastructure.

```terraform

module "docker-registry" {
  source = "github.com/rtlnl/terraform-aws-docker-registry"
  ref = ""

  http_secret            = "randomlygeneratedstring"
  s3_access_key          = "<s3_access_key>"
  s3_secret_key          = "<s3_secret_key"
  ingress_dns            = "http://yourdns.example.com"
  ingress_annotations    = {
      "kubernetes.io/ingress.class":"nginx" #if you use nginx as your ingress controller for example
  }
  namespace_annotations  = {}
}
``` 

After applying, you should now be able to push docker images to your registry by including the DNS when tagging your images.