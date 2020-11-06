locals {
  mime_types = {
    htm   = "text/html"
    html  = "text/html"
    css   = "text/css"
    scss  = "text/css"
    ttf   = "font/ttf"
    js    = "application/javascript"
    map   = "application/javascript"
    json  = "application/json"
    jpg   = "image/jpeg"
    png   = "image/png"
    svg   = "image/svg+xml"
    woff  = "font/woff"
    woff2 = "font/woff2"
    otf   = "font/otf"
    eot   = "application/vnd.ms-fontobject"
    txt   = "text/plain"
  }

  files_location = "${path.root}/../public/"

}


resource "aws_s3_bucket" "domain_bucket" {
  bucket = var.domain_name
  acl    = "public-read"
  policy = data.aws_iam_policy_document.domain_bucket_policy.json

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}


resource "aws_s3_bucket" "www_subdomain_bucket" {
  bucket = "www.${var.domain_name}"

  website {
   redirect_all_requests_to = aws_s3_bucket.domain_bucket.bucket
  }
}
data "aws_iam_policy_document" "domain_bucket_policy"{
  statement {
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.domain_name}/*"]
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }
 
}

resource "aws_s3_bucket_object" "web_app_files" {
  for_each     = fileset(local.files_location, "**/*.*")
  bucket       = var.domain_name
  key          = replace(each.value, local.files_location, "")
  source       = "${local.files_location}${each.value}"
  acl          = "public-read"
  etag         = filemd5("${local.files_location}${each.value}")
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
  depends_on   = [aws_s3_bucket.domain_bucket]
}

output "web_app_endpoint" {
  value = "http://${aws_s3_bucket.domain_bucket.website_endpoint}"
}
