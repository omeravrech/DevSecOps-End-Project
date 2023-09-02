provider "aws" {
    region                  = "eu-central-1"
}

resource "aws_vpc" "production-vpc" {
    cidr_block              = "10.0.0.0/16"
    enable_dns_support      = true
    enable_dns_hostnames    = true
}

resource "aws_subnet" "frontend-subnet" {
    vpc_id                  = aws_vpc.production-vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
}
resource "aws_subnet" "backend-subnet" {
    vpc_id                  = aws_vpc.production-vpc.id
    cidr_block              = "10.0.2.0/24"
    map_public_ip_on_launch = true
}

resource "aws_security_group" "sg-ter-1" {
    vpc_id = aws_vpc.production-vpc.id

    ingress  {
        description         = "allow HTTP connectivity to vpc"
        from_port           = 80
        to_port             = 80
        protocol            = "tcp"
        cidr_blocks         = [aws_subnet.backend-subnet.cidr_block, aws_subnet.frontend-subnet.cidr_block]
    }
    ingress {
        description         = "allow ssh connectivity to vpc"
        from_port           = 22
        to_port             = 22
        protocol            = "tcp"
        cidr_blocks         = [aws_vpc.production-vpc.cidr_block]
    }

    egress {
        description         = "Allow all exit traffic"
        from_port           = 0
        to_port             = 0
        protocol            = "-1"
        cidr_blocks         = ["0.0.0.0/0"]
    }
 }

resource "tls_private_key" "this" {
    count                   = 2
    algorithm               = "RSA"
    rsa_bits                = 2048
}


resource "aws_key_pair" "backend-key-pair" {
    count                   = 1
    key_name                = "backend-public-key"
    public_key              = trimspace(tls_private_key.this[0].public_key_openssh)
}

resource "aws_key_pair" "frontend-key-pair" {
    count                   = 1
    key_name                = "frontend-public-key"
    public_key              = trimspace(tls_private_key.this[1].public_key_openssh)
}
