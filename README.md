# Private Docker Registry

This repo contains a terraform module to deploy a privately managed docker registry in your AWS EKS Kubernetes cluster. The images will be stored on s3.

## Usage

Look into the minimal [example](examples/minimal) for an example for simple usage of the module.
After terraform applying, you should now be able to push docker images to your registry by including the DNS when tagging your images.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| AWS | n/a |
| kubernetes | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| http\_secret | A random piece of data used to sign state that may be stored with the client to protect against tampering. For production environments you should generate a random piece of data using a cryptographically secure random generator. | `string` | n/a | yes |
| image\_pull\_policy | Image pull policy | `string` | `"IfNotPresent"` | no |
| image\_version | Version of the docker image to be used | `string` | `"2.7.1"` | no |
| ingress\_annotations | ingress annotations to add | `map(string)` | `{}` | no |
| ingress\_dns | DNS name for the ingress | `string` | n/a | yes |
| labels | Contains the labels the kubernetes resources should have | `map(string)` | <pre>{<br>  "app": "docker-registry"<br>}</pre> | no |
| namespace | Name of the namespace where the module should be installed | `string` | `"docker-registry"` | no |
| namespace\_annotations | Annotations to be added to the namespace | `map(string)` | `{}` | no |
| s3\_access\_key | s3 access key to access the bucket | `string` | n/a | yes |
| s3\_bucket | s3 bucket where the images will be stored | `string` | n/a | yes |
| s3\_region | aws region where the s3 bucket lives | `string` | n/a | yes |
| s3\_secret\_key | s3 secret key to access the bucket | `string` | n/a | yes |
| service\_port | Port where the service should be defined on | `number` | `5000` | no |

## Outputs

No output.
