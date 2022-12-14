# S3 bucket for backend 
resource "aws_s3_bucket" "capstone-s3-bucket" {

  bucket        = "sara-project"
  force_destroy = true
  # Enable versioning to see full revision history of our state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name = "S3 Remote Terraform State Store"
  }

}