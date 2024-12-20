# Primary region 
variable "primary_region" {
  description = "Primary region for the deployment"
  type        = string
  default     = "us-east-1"
}

# Secondary region
variable "secondary_region" {
  description = "Secondary region for the deployment"
  type        = string
  default     = "us-west-2"
}

# Region input variables 
variable "regions" {
  description = "Mapping of region-specific configurations"
  type = map(object({
    vpc_cidr_block = string
    port_http      = number
    port_https     = number
    protocol       = string
    http_method    = string
    environment    = string
    log_name       = string
    region         = string
    table_name     = string
    hash_key       = string
  }))
}
