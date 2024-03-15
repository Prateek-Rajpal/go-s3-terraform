output "Instance_id" {
  description = "The ID of the instance"
  value       = module.ec2.id
}

output "arn" {
  description = "The ARN of the instance"
  value       = module.ec2.arn
}

output "instance_state" {
  description = "The state of the instance. One of: `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped`"
  value       = module.ec2.instance_state
}



output "public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2.public_dns
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.ec2.public_ip
}




output "bucket_arn" {
  value = aws_s3_bucket.demo_bucket.arn
}