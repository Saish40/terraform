resource "aws_s3_bucket" "static_bucket" {
  bucket = var.bucket
}

resource "aws_s3_bucket_ownership_controls" "bucket_controls" {
  bucket = aws_s3_bucket.static_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_controls,
    aws_s3_bucket_public_access_block.public_access,
  ]

  bucket = aws_s3_bucket.static_bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.static_bucket.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.static_bucket.id
  key = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "admin" {
  bucket = aws_s3_bucket.static_bucket.id
  key = "admin.png"
  source = "admin.png"
  acl = "public-read"
}

resource "aws_s3_object" "data" {
  bucket = aws_s3_bucket.static_bucket.id
  key = "data.png"
  source = "data.png"
  acl = "public-read"
}

resource "aws_s3_object" "terraform" {
  bucket = aws_s3_bucket.static_bucket.id
  key = "terraform.png"
  source = "terraform.png"
  acl = "public-read"
}

resource "aws_s3_object" "style_css" {
  bucket = aws_s3_bucket.static_bucket.id
  key = "style.css"
  source = "style.css"
  acl = "public-read"
  content_type = "text/css"
}

resource "aws_s3_object" "master_css" {
  bucket = aws_s3_bucket.static_bucket.id
  key = "master.css"
  source = "master.css"
  acl = "public-read"
  content_type = "text/css"
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.static_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [ aws_s3_bucket_acl.bucket_acl ]
}