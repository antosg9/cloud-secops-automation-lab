variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Prefix used to name and tag resources."
  type        = string
  default     = "zt-bastion"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "owner" {
  description = "Person or team responsible for the resources (Owner tag)."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet (DMZ): hosts only the bastion."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet: workloads with no direct Internet exposure."
  type        = string
  default     = "10.0.2.0/24"
}

variable "admin_ip_cidr" {
  description = "Administrator public IP in CIDR notation (e.g. 203.0.113.42/32)."
  type        = string

  validation {
    condition = (
      can(cidrhost(var.admin_ip_cidr, 0)) &&
      can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/(2[4-9]|3[0-2])$", var.admin_ip_cidr))
    )
    error_message = "admin_ip_cidr must be a restricted IPv4 CIDR (/24 to /32). 0.0.0.0/0 is forbidden."
  }
}
