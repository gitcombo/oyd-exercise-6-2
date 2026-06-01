# oyd-exercise-6-2 — ALB with Listener and Target Group

## Overview

This repository provisions an Application Load Balancer (ALB) in front of an existing EC2 instance running the MediaStream video-transcoding API.

**Architecture:**
- The `setup/` workspace provisions the baseline VPC (2 public subnets across 2 AZs) and the EC2 instance.
- The root workspace provisions the ALB layer: security group, target group, ALB, HTTP listener, and target registration — all resolved via data sources (no hardcoded IDs).

## Prerequisites

- AWS CLI configured with credentials that can create VPC, EC2, and ALB resources.
- Terraform >= 1.8 installed and on `PATH`.

## How to Deploy

### 1. Apply the setup workspace

```bash
cd setup/
terraform init
terraform apply -auto-approve
cd ..
```

### 2. Apply the root workspace

```bash
terraform init
terraform apply -var-file=terraform.tfvars
```

### 3. Collect evidence

```bash
terraform state list > evidence/state-list.txt
terraform output     > evidence/outputs.txt
```

## Variables

| Name | Type | Default | Description |
|---|---|---|---|
| `region` | string | `us-east-1` | AWS region |
| `vpc_name` | string | `mediastream-vpc` | Name tag to look up the existing VPC |
| `instance_name` | string | `mediastream-api` | Name tag to look up the existing EC2 instance |
| `listener_port` | number | `80` | Port the ALB listener accepts traffic on |
| `environment` | string | — | Deployment environment |

## Outputs

| Name | Description |
|---|---|
| `alb_dns_name` | Public DNS name of the ALB |
| `alb_arn` | ARN of the ALB |
| `target_group_arn` | ARN of the target group |

## Evidence

### terraform state list

```
data.aws_instance.api
data.aws_subnets.public
data.aws_vpc.main
aws_lb.main
aws_lb_listener.http
aws_lb_target_group.api
aws_lb_target_group_attachment.api
aws_security_group.alb

```

### terraform output

```
alb_arn = "arn:aws:elasticloadbalancing:us-east-1:672755422477:loadbalancer/app/mediastream-alb/328257d25e62e2b2"
alb_dns_name = "mediastream-alb-425723988.us-east-1.elb.amazonaws.com"
target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:672755422477:targetgroup/mediastream-api-tg/f9f9d1f7bfaa62de"

```
