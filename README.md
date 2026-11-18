
# aws-multi-region-terraform

AWS Multi-Region Infrastructure with Terraform

This project uses Terraform to build AWS infrastructure across two regions so that an application stays available and redundant if one region has a problem. The infrastructure is split into reusable modules, and the Terraform state is stored remotely in Amazon S3.

Overview
Primary region: set with the aws_region variable (eu-west-1 in the example file)
Second region: Africa (Cape Town), af-south-1, configured as an aliased provider named south_africa
Goal: high availability and redundancy by hosting the application in two regions
Approach: infrastructure as code, with each part of the stack in its own module
Architecture

Each region runs the same application stack, and Route 53 sits in front of both.

                        Route 53 (DNS)
                             |
              +--------------+--------------+
              |                             |
        Region 1 (eu-west-1)        Region 2 (af-south-1)
              |                             |
         Application                   Application
        Load Balancer                 Load Balancer
              |                             |
       EC2 Auto Scaling              EC2 Auto Scaling
            Group                         Group
              |                             |
         Amazon RDS                    Amazon RDS
              |                             |
             VPC                           VPC
Modules
Module	What it creates
vpc	Network for each region: VPC, subnets and routing
alb	Application Load Balancer that receives traffic and spreads it across instances
compute	EC2 instances managed by an Auto Scaling Group
rds	Amazon RDS database for the application
route53	DNS records that point users to the application

Project Structure
.
├── backend.tf                 # S3 remote state configuration
├── main.tf                    # Calls the modules for each region
├── providers.tf               # AWS providers for both regions
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── terraform.tfvars.example   # Example variable values
├── .terraform.lock.hcl        # Provider version lock file
├── bootstrap/                 # One-time setup for remote state
└── modules/
    ├── vpc/
    ├── alb/
    ├── compute/
    ├── rds/
    └── route53/
    
Remote State

Terraform state is stored in an S3 bucket instead of on a local machine. This keeps state safe, shared and versioned, and it uses S3 native state locking (use_lockfile = true), so no DynamoDB table is needed. The bootstrap/ folder sets up what the remote state needs and is run once before the main project.

Prerequisites
Terraform >= 1.10.0 (native S3 locking needs 1.10 or later)
AWS provider ~> 6.0
AWS CLI installed and configured with credentials that can create the resources
Access to the second region. af-south-1 is an opt-in region, so it must be enabled in your AWS account first

Usage
Clone the repository
git clone https://github.com/fkiverenge/aws-multi-region-terraform.git
cd aws-multi-region-terraform
Set up remote state (one time)
cd bootstrap
terraform init
terraform apply
cd ..
Set your own state bucket name in backend.tf, replacing example-bucket-name.
Create your variables file
cp terraform.tfvars.example terraform.tfvars

Edit terraform.tfvars with your own values. This file is ignored by Git.

Deploy
terraform init
terraform plan
terraform apply

Variables
Variable	Description	Example
aws_region	Primary AWS region	eu-west-1
vpc_cidr	CIDR block for the VPC	10.10.0.0/16

See variables.tf for the full list.

Security Notes
State files, .tfvars files and the .terraform/ folder are excluded from Git with .gitignore.
No credentials are stored in the code. Terraform uses the AWS credentials from your own environment.
Use your own bucket name and values. The ones in this repository are placeholders.


Cost and Cleanup

Resources such as load balancers, EC2 instances and RDS databases cost money while they run. When you finish testing, remove everything:

terraform destroy
Possible Improvements
Add automated checks (terraform fmt, validate and security scanning) with GitHub Actions
Add health checks and failover routing in Route 53
Add monitoring and alerting with CloudWatch
Add cross-region database replication

Author

Fredrick Kiverenge, Cloud and DevOps Engineer

LinkedIn: https://www.linkedin.com/in/fredrick-kiverenge-252a9990-solutions-architect/
