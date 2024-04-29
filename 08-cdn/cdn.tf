resource "aws_cloudfront_distribution" "eternal" {
  enabled             = true
  aliases             = ["web-${var.tags.component}.${var.zone_name}"]
  #default_root_object = "website/index.html"
  origin {
    domain_name = "web-dev.eternaltrainings.online"
    origin_id   = "web-dev.eternaltrainings.online"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      
}
  
  }

#  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "web-dev.eternaltrainings.online"
    cache_policy_id = data.aws_cloudfront_cache_policy.cache.id

   
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
  }
# Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "web-dev.eternaltrainings.online"
    cache_policy_id = data.aws_cloudfront_cache_policy.no_cache.id
   
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "web-dev.eternaltrainings.online"
    viewer_protocol_policy = "https-only" # other options - https only, http
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    
  }
}
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA"]
    }
  }
  tags =  {
    
        "Project"   =  var.project
        "ManagedBy" = "Terraform"
  } 
  viewer_certificate {
    acm_certificate_arn      = data.aws_ssm_parameter.eternaldomain_certificate_arn.value
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
 
resource "aws_route53_record" "eternal_cdn_dns" {
  zone_id = var.zone_id
  name    = "web-cloudfront"
  type    = "A" # OR "AAAA"
  

  alias {
      name                   = aws_cloudfront_distribution.eternal.domain_name
      zone_id                = aws_cloudfront_distribution.eternal.hosted_zone_id
      evaluate_target_health = true
  }
}