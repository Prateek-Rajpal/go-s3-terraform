variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "assume_role_arn" {
  description = "assume role in which account to create"
  type        = string
  default     = ""
}


// placement group

variable "pg_name" {
  description = "Name of the Placement group"
  type        = string
  default     = ""
}

variable "strategy" {
  description = "strategy - (Required) The placement strategy. Can be 'cluster', 'partition' or 'spread'."
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "availability_zone" {
  description = "AZ to start the instance in"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}


variable "monitoring" {
  description = "(Optional) If true, the launched EC2 instance will have detailed monitoring enabled."
  type        = bool
  default     = false
}





//root block device
variable "create_kms_key" {
  description = "Whether to create kms key for the EBS Block Device"
  type        = bool
  default     = false
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
  default = [{
    encrypted   = true
    volume_type = "gp3"
    throughput  = 200
    volume_size = 10
    tags = {
      Name = "my-root-block"
    }
  }, ]
}


variable "ec2_tags" {
  description = "A mapping of tags to assign to EC2 Instance"
  type        = map(string)
  default     = {}
}



variable "bucket_name" {
    description = "name of the s3 bucket to be created"
    type = string
    default = null
}

