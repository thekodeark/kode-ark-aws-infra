resource "aws_s3_bucket" "log" {
  bucket = "kode-ark-access-log"
  tags = {
    Name = "Server Access Log Bucket"
  }
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket
  tags = {
    Name = "Kode Ark Web Application"
  }
    acl = "public-read"
  logging {
    target_bucket = aws_s3_bucket.log.id
    target_prefix = "log"
  }
}
