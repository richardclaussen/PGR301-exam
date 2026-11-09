resource "aws_s3_bucket" "images" {
  bucket = "wishifai-uploads-candidate${var.candidate_number}"
}