# FreshCart keeps its product photos in this storage bucket (AWS S3).
# Nothing here is ever created. Checkov only reads this file.

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "product_photos" {
  bucket = "freshcart-product-photos-demo"
}

# PROBLEM: all four "block public access" safety switches are turned off.
resource "aws_s3_bucket_public_access_block" "product_photos" {
  bucket = aws_s3_bucket.product_photos.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
