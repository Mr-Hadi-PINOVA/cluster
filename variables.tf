variable "region" {
  type = string
}

variable "assume_role_arn" {
  description = "Optional role ARN that Terraform should assume before managing resources. Leave null to rely on the caller's credentials/session."
  type        = string
  default     = null
}

variable "pb_arn" {
  description = "Permissions boundary ARN required for IAM roles."
  type        = string
  default     = "arn:aws:iam::640168415309:policy/MSK-Permission-Boundary"
}

variable "access_scope" {
  description = "Access scope tag value required by organizational ABAC policies."
  type        = string
  default     = "team-x"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string) # 2+ private subnets in different AZs
}

variable "cluster_name" {
  type = string
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "log_kms_key_arn" {
  type    = string
  default = null
}

# IAM scoping for Kafka resources
variable "producer_topic_prefixes" {
  type    = list(string)
  default = ["exchg."]
}

variable "consumer_topic_prefixes" {
  type    = list(string)
  default = ["exchg."]
}

variable "consumer_group_names" {
  type    = list(string)
  default = ["crypto-readers"]
}

# Collector SG settings (the SG we create for EC2 collectors)
variable "collector_sg_name" {
  type    = string
  default = "msk-ec2-collectors"
}

variable "collector_sg_description" {
  type    = string
  default = "EC2 collectors for MSK"
}

variable "consumer_sg_name" {
  type    = string
  default = "msk-ec2-consumers"
}

variable "consumer_sg_description" {
  type    = string
  default = "EC2 consumers for MSK"
}

variable "collector_sg_egress_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"] # allows NAT/Internet egress for collectors to reach exchanges
}

variable "tags" {
  type    = map(string)
  default = {}
}
