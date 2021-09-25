resource "aws_s3_bucket" "this" {
  bucket = var.bucket
  tags = {
    Name = "Kode Ark Web Application"
  }
  #  acl = "public-read"
}
