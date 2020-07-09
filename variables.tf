variable "image_version" {
  type        = string
  description = "Version of the docker image to be used"
  default     = "2.7.1"
}

variable "image_pull_policy" {
  type        = string
  description = "Image pull policy"
  default     = "IfNotPresent"
}

variable "namespace" {
  type        = string
  description = "Name of the namespace where the module should be installed"
  default     = "docker-registry"
}

variable "namespace_annotations" {
  type        = map(string)
  description = "Annotations to be added to the namespace"
  default     = {}
}

variable "labels" {
  type        = map(string)
  description = "Contains the labels the kubernetes resources should have"
  default = {
    app = "docker-registry"
  }
}

variable "http_secret" {
  type        = string
  description = "A random piece of data used to sign state that may be stored with the client to protect against tampering. For production environments you should generate a random piece of data using a cryptographically secure random generator."
}

variable "s3_access_key" {
  type        = string
  description = "s3 access key to access the bucket"
}

variable "s3_secret_key" {
  type        = string
  description = "s3 secret key to access the bucket"
}

variable "s3_bucket" {
  type        = string
  description = "s3 bucket where the images will be stored"
}

variable "s3_region" {
  type        = string
  description = "aws region where the s3 bucket lives"
}

variable "service_port" {
  type        = number
  description = "Port where the service should be defined on"
  default     = 5000
}

variable "ingress_annotations" {
  description = "ingress annotations to add"
  type        = map(string)
  default     = {}
}

variable "ingress_dns" {
  type        = string
  description = "DNS name for the ingress"
}
