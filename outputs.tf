output "s3" {
  value = {
    arn         = aws_s3_bucket.this.arn
    domain_name = aws_s3_bucket.this.arn
  }
}
