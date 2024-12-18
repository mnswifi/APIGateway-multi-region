variable "primary_region" {
    description = "The region for the deployment"
    type = string  
    default = "us-east-1"
}


variable "secondary_region" {
    description = "The region for the deployment"
    type = string 
    default = "us-west-2" 
}


variable "regions" {
  description = "Mapping of region-specific configurations"
  type = map(object({
    vpc_cidr_block = string
    port           = number
    protocol       = string
    http_method    = string
    environment    = string
  }))
}
