output "instance_public_ip" {
  value = aws_eip.app.public_ip
}

output "instance_id" {
  value = aws_instance.app.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}

output "vpc_id" {
  value = aws_vpc.main.id
}
