variable "aws_region" {
  description = "Région AWS de déploiement."
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Préfixe pour nommer et tagger les ressources."
  type        = string
  default     = "zt-bastion"
}

variable "environment" {
  description = "Environnement (dev, staging, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment doit valoir dev, staging ou prod."
  }
}

variable "owner" {
  description = "Responsable des ressources (tag Owner)."
  type        = string
}

variable "vpc_cidr" {
  description = "Plage d'adresses du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Subnet public (DMZ) : héberge uniquement le Bastion"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Subnet privé : workloads sans exposition Internet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "admin_ip_cidr" {
  description = "IP publique de l'administrateur en CIDR (/32)"
  type        = string

  validation {
    condition = (
      can(cidrhost(var.admin_ip_cidr, 0)) &&
      can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/(2[4-9]|3[0-2])$", var.admin_ip_cidr))
    )
    error_message = "admin_ip_cidr doit être un CIDR IPv4 restreint (/24 à /32). 0.0.0.0/0 est interdit."
  }
}
