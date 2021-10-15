resource "aws_s3_bucket" "log" {
  bucket = "kode-ark-access-log"
  acl    = "log-delivery-write"
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
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  versioning {
    enabled = true
  }
  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = 120
    }

    noncurrent_version_transition {
      storage_class = "GLACIER"
      days          = 60
    }

    noncurrent_version_transition {
      storage_class = "ONEZONE_IA"
      days          = 30
    }

    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }

    expiration {
      days = 120
    }
  }
}

# Rule 1 to define the bucket policy
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  #  policy = jsonencode({
  #    Version = "2012-10-17"
  #    Id      = "StaticWebSite"
  #    Statement = [
  #      {
  #        Sid       = "ReadOnlyAccess"
  #        Effect    = "Allow"
  #        Principal = "*"
  #        Action    = "s3:GetObject"
  #        Resource = [
  #          aws_s3_bucket.this.arn,
  #          "${aws_s3_bucket.this.arn}/*"
  #        ]
  #      }
  #    ]
  #  })
  policy = data.aws_iam_policy_document.this.json
}

#Rule2 of Policy Document
data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }
}
