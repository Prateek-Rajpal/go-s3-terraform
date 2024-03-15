provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.assume_role_arn
  }
}

## Creating s3 bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = var.bucket_name # Use the variable if defined, otherwise replace with the desired name
  acl    = "private"

  # Optional configuration
  versioning {
    enabled = false
  }
}

## Iam policy to be attached with iam role
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_full_access_policy"
  description = "Provides ec2 access to s3 buckets"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListAllMyBuckets"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = aws_s3_bucket.demo_bucket.arn
      },
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.demo_bucket.arn}/*"
      }
    ]
  })
}

## Iam Role for ec2 instance
resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_full_access_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

## Attaching policy to role
resource "aws_iam_role_policy_attachment" "s3_full_access_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

## Using iam instance profile for providing role to ec2 instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}


## creating ec2 instance using module
module "ec2" {
  source = "./modules/ec2_instance"

  name                        = var.instance_name
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  user_data_base64            = filebase64("./userdata.sh")
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  monitoring                  = var.monitoring
  tags                        = var.ec2_tags
  depends_on                  = [aws_s3_bucket.demo_bucket]
}



