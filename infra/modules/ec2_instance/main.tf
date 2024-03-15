## Security group for ec2 instance
resource "aws_security_group" "go-web-server" {
  name = "go-api-security-group"
  vpc_id = var.vpc_id 
  ingress {
    description = "ssh-port"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["122.19.112.1/32", "110.151.37.254/32"] # Restrict to specific IP
  }
  ingress {
    description = "go-api-port"
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["122.19.112.1/32", "110.151.37.254/32"] # Restrict to specific IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1 // allow all
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "go-web-server-security_group"
  }
}



resource "aws_instance" "this" {

  ami                  = var.ami
  instance_type        = var.instance_type
  cpu_core_count       = var.cpu_core_count
  cpu_threads_per_core = var.cpu_threads_per_core
  user_data            = var.user_data
  user_data_base64     = var.user_data_base64

  availability_zone = var.availability_zone
  subnet_id         = var.subnet_id
  security_groups   = [aws_security_group.go-web-server.id]

  key_name             = var.key_name
  monitoring           = var.monitoring
  iam_instance_profile = var.iam_instance_profile
  associate_public_ip_address = var.associate_public_ip_address

  ebs_optimized = var.ebs_optimized

  provisioner "file" {
    source      = "../go-api/"
    destination = "/home/ubuntu/"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/home/ubuntu/key_pair.pem") ## this is not a secure way, instead we can store private key in secret manager
      host        = self.public_ip
    }
  }
}

# data "aws_secretsmanager_secret_version" "key" {
#   secret_id = var.private_key_arn
# }
