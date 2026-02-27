# 1. Define the Provider
provider "aws" {
  region = "us-east-1" # Change this to your preferred region
}

# 2. Create a Security Group
resource "aws_security_group" "web_access" {
  name        = "web_access_sg"
  description = "Allow SSH, HTTP, and HTTPS traffic"

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For better security, replace with your IP: "X.X.X.X/32"
  }

  # HTTP Access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS Access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules (Allow all traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Data source to fetch the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS Account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 4. Create the EC2 Instance
resource "aws_instance" "my_ubuntu_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  
  # Ensure you have already created this key pair in the AWS Console
  key_name      = "your-key-pair-name" 

  vpc_security_group_ids = [aws_security_group.web_access.id]

  tags = {
    Name = "Terraform-Ubuntu-T3Micro"
  }
}
