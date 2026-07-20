provider "aws" {
  region = "ap-south-1"
}

# 1. Fetch the latest official Ubuntu 22.04 LTS AMI dynamically for ap-south-1
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS Account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-jammy-22.04-amd64-server-*", "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. VPC Creation
resource "aws_vpc" "uas_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "uas-vpc" }
}

# 3. Public Subnet
resource "aws_subnet" "uas_public_subnet" {
  vpc_id                  = aws_vpc.uas_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags                    = { Name = "uas-public-subnet" }
}

# 4. Internet Gateway
resource "aws_internet_gateway" "uas_gw" {
  vpc_id = aws_vpc.uas_vpc.id
  tags   = { Name = "uas-igw" }
}

# 5. Route Table & Association
resource "aws_route_table" "uas_rt" {
  vpc_id = aws_vpc.uas_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.uas_gw.id
  }
}

resource "aws_route_table_association" "uas_rta" {
  subnet_id      = aws_subnet.uas_public_subnet.id
  route_table_id = aws_route_table.uas_rt.id
}

# 6. Security Group
resource "aws_security_group" "uas_sg" {
  name        = "uas-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.uas_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 7. EC2 Instance
resource "aws_instance" "uas_server" {
  ami                    = data.aws_ami.ubuntu.id # Uses dynamic AMI lookup
  instance_type          = "t3.micro"            # Free Tier eligible in ap-south-1
  subnet_id              = aws_subnet.uas_public_subnet.id
  vpc_security_group_ids = [aws_security_group.uas_sg.id]
  key_name               = "uas-key"             # Ensure this Key Pair exists in Mumbai console!

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = { Name = "uas-production-server" }
}

# 8. S3 Bucket
resource "aws_s3_bucket" "uas_assets" {
  bucket        = "university-system-assets-unique-suffix-2026"
  force_destroy = true
}

# Output
output "server_public_ip" {
  value = aws_instance.uas_server.public_ip
}