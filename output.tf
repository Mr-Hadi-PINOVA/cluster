locals {
  infrastructure_summary = {
    msk_cluster = {
      arn                        = aws_msk_serverless_cluster.this.arn
      cluster_uuid               = aws_msk_serverless_cluster.this.cluster_uuid
      bootstrap_brokers_sasl_iam = aws_msk_serverless_cluster.this.bootstrap_brokers_sasl_iam
      security_group_ids         = aws_msk_serverless_cluster.this.vpc_config[0].security_group_ids
      subnet_ids                 = aws_msk_serverless_cluster.this.vpc_config[0].subnet_ids
      tags                       = aws_msk_serverless_cluster.this.tags
    }
    cloudwatch = {
      log_group_name = aws_cloudwatch_log_group.msk_broker.name
      log_group_arn  = aws_cloudwatch_log_group.msk_broker.arn
      retention_days = aws_cloudwatch_log_group.msk_broker.retention_in_days
    }
    security_groups = {
      collectors = {
        id   = aws_security_group.collector.id
        arn  = aws_security_group.collector.arn
        tags = aws_security_group.collector.tags
      }
      consumers = {
        id   = aws_security_group.consumers.id
        arn  = aws_security_group.consumers.arn
        tags = aws_security_group.consumers.tags
      }
      msk_brokers = {
        id   = aws_security_group.msk_brokers.id
        arn  = aws_security_group.msk_brokers.arn
        tags = aws_security_group.msk_brokers.tags
      }
      ingress_rules = [
        {
          key                          = "collectors"
          id                           = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_collector.id
          arn                          = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_collector.arn
          referenced_security_group_id = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_collector.referenced_security_group_id
          description                  = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_collector.description
          from_port                    = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_collector.from_port
          to_port                      = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_collector.to_port
          protocol                     = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_collector.ip_protocol
        },
        {
          key                          = "consumers"
          id                           = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_consumers.id
          arn                          = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_consumers.arn
          referenced_security_group_id = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_consumers.referenced_security_group_id
          description                  = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_consumers.description
          from_port                    = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_consumers.from_port
          to_port                      = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_consumers.to_port
          protocol                     = aws_vpc_security_group_ingress_rule.msk_iam_9098_from_consumers.ip_protocol
        }
      ]
      egress_rule = {
        id                     = aws_vpc_security_group_egress_rule.msk_all_egress.id
        arn                    = aws_vpc_security_group_egress_rule.msk_all_egress.arn
        cidr_ipv4              = aws_vpc_security_group_egress_rule.msk_all_egress.cidr_ipv4
        ip_protocol            = aws_vpc_security_group_egress_rule.msk_all_egress.ip_protocol
        security_group_rule_id = aws_vpc_security_group_egress_rule.msk_all_egress.security_group_rule_id
      }
    }
    iam = {
      roles = {
        collector = {
          name = aws_iam_role.collector_role.name
          arn  = aws_iam_role.collector_role.arn
        }
      }
      instance_profiles = {
        collector = {
          name = aws_iam_instance_profile.collector_profile.name
          arn  = aws_iam_instance_profile.collector_profile.arn
        }
      }
      policies = {
        msk_control_plane = {
          name = aws_iam_policy.msk_control_plane.name
          arn  = aws_iam_policy.msk_control_plane.arn
        }
        producer = {
          name = aws_iam_policy.producer.name
          arn  = aws_iam_policy.producer.arn
        }
        consumer = {
          name = aws_iam_policy.consumer.name
          arn  = aws_iam_policy.consumer.arn
        }
      }
      attachments = {
        collector_control = {
          role_name  = aws_iam_role_policy_attachment.collector_control_attach.role
          policy_arn = aws_iam_role_policy_attachment.collector_control_attach.policy_arn
        }
        collector_producer = {
          role_name  = aws_iam_role_policy_attachment.collector_producer_attach.role
          policy_arn = aws_iam_role_policy_attachment.collector_producer_attach.policy_arn
        }
      }
    }
  }
}

output "msk_cluster_arn" {
  value       = aws_msk_serverless_cluster.this.arn
  description = "MSK Serverless cluster ARN"
}

output "msk_cluster_uuid" {
  value       = aws_msk_serverless_cluster.this.cluster_uuid
  description = "UUID used in Kafka ARNs"
}

output "bootstrap_brokers_sasl_iam" {
  value       = aws_msk_serverless_cluster.this.bootstrap_brokers_sasl_iam
  description = "Comma-separated brokers for SASL/IAM (TLS :9098)"
}

output "msk_broker_security_group_id" {
  value       = aws_security_group.msk_brokers.id
  description = "Security group ID for MSK brokers"
}

output "collector_instance_profile_name" {
  value       = aws_iam_instance_profile.collector_profile.name
  description = "Attach this instance profile to your EC2 collectors"
}

output "consumer_policy_arn" {
  value       = aws_iam_policy.consumer.arn
  description = "Attach this to consumer roles in other teams"
}

output "collector_sg_id" {
  value       = aws_security_group.collector.id
  description = "Security Group ID created for EC2 collectors"
}

output "consumer_sg_id" {
  value       = aws_security_group.consumers.id
  description = "Security Group ID created for MSK consumers"
}

output "infrastructure_summary_json" {
  description = "JSON summary of the AWS resources created by this configuration"
  value       = jsonencode(local.infrastructure_summary)
}

resource "local_file" "infrastructure_summary" {
  content  = jsonencode(local.infrastructure_summary)
  filename = "${path.module}/resources.json"
}
