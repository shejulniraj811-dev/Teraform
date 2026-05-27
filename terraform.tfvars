###############################################################################
# terraform.tfvars
#
# Concrete values for the variables defined in variables.tf.
# Terraform loads this file automatically. Override any default here.
###############################################################################

# Provider / Region
aws_region  = "us-east-1"
aws_profile = ""

# EC2 Instance
ami_id         = "ami-091138d0f0d41ff90"
instance_type  = "t3.micro"
instance_count = 1
key_name       = "aws_key.pem"

# Networking
subnet_id                   = ""
vpc_security_group_ids      = ["sg-0981f1bdf4af6c11d"]
associate_public_ip_address = true

# Storage (root EBS volume)
root_volume_size      = 8
root_volume_type      = "gp3"
root_volume_encrypted = true

# Monitoring
enable_detailed_monitoring = false

# Naming & Tagging
instance_name = "Niraj"
environment   = "dev"

tags = {
  Owner   = "Niraj"
  Project = "Teraform"
}

# Remote Backend (S3) — must match values in backend.tf
tf_state_bucket = "niraj-terraform-state"
tf_state_key    = "dev/ec2/terraform.tfstate"
tf_state_region = "us-east-1"
tf_lock_table   = "niraj-terraform-lock"
