###############################################################################
# backend.tf
#
# Remote backend — stores Terraform state in S3 and uses DynamoDB for
# state locking so concurrent runs don't corrupt the state file.
#
# ⚠️  IMPORTANT — before running `terraform init`:
#   1. Create the S3 bucket (versioning + encryption enabled).
#   2. Create the DynamoDB table with a partition key named "LockID" (String).
#   3. Fill in the correct values below (or pass them via -backend-config flags).
#
# Bucket & table creation snippet (one-time, run with the AWS CLI):
#
#   aws s3api create-bucket \
#     --bucket niraj-terraform-state \
#     --region us-east-1
#
#   aws s3api put-bucket-versioning \
#     --bucket niraj-terraform-state \
#     --versioning-configuration Status=Enabled
#
#   aws s3api put-bucket-encryption \
#     --bucket niraj-terraform-state \
#     --server-side-encryption-configuration \
#       '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
#
#   aws dynamodb create-table \
#     --table-name niraj-terraform-lock \
#     --attribute-definitions AttributeName=LockID,AttributeType=S \
#     --key-schema AttributeName=LockID,KeyType=HASH \
#     --billing-mode PAY_PER_REQUEST \
#     --region us-east-1
###############################################################################

terraform {
  # ── Required provider version constraint ──────────────────────────────────
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # ── S3 Remote Backend ─────────────────────────────────────────────────────
  backend "s3" {
    # S3 bucket that will store the .tfstate file.
    # Must already exist — Terraform does not create it.
    bucket = "niraj-terraform-state"

    # Path (key) inside the bucket for this state file.
    # Using environment in the path keeps dev/staging/prod states separate.
    key = "dev/ec2/terraform.tfstate"

    # Region where the bucket lives.
    region = "us-east-1"

    # ── Encryption at rest ──────────────────────────────────────────────────
    # Uses the bucket's default AES-256 SSE (set during bucket creation above).
    # Switch to "aws:kms" and set kms_key_id if you need a customer-managed key.
    encrypt = true

    # ── State locking (DynamoDB) ────────────────────────────────────────────
    # Prevents two people / CI jobs from running `terraform apply` at the same
    # time and corrupting the state.  Table must have a String partition key
    # named exactly "LockID".
    dynamodb_table = "niraj-terraform-lock"

    # ── Access credentials ──────────────────────────────────────────────────
    # Leave blank to use the default credential chain (env vars, ~/.aws, etc.).
    # Uncomment and set if you need a named profile:
    # profile = "my-profile"
  }
}
