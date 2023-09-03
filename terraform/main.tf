provider "aws" {
    region                   = "eu-central-1"
}
resource "aws_vpc" "production_vpc" {
    cidr_block               = "10.0.0.0/16"
    enable_dns_support       = true
    enable_dns_hostnames     = true
}

resource "aws_subnet" "subnet_backend" {
    vpc_id                   = aws_vpc.production_vpc.id
    cidr_block               = "10.0.1.0/24"
    availability_zone        = "eu-central-1a"
    map_public_ip_on_launch  = true
}

resource "aws_subnet" "subnet_frontend" {
    vpc_id                   = aws_vpc.production_vpc.id
    cidr_block               = "10.0.2.0/24"
    availability_zone        = "eu-central-1a"
    map_public_ip_on_launch  = true
}

resource "aws_internet_gateway" "default_gw" {
    vpc_id                   = aws_vpc.production_vpc.id
}

resource "aws_default_route_table" "production_route_table" {
    default_route_table_id   = aws_vpc.production_vpc.default_route_table_id
    route {
        cidr_block           = "0.0.0.0/0"
        gateway_id           = aws_internet_gateway.default_gw.id
    }
    route {
        cidr_block           = "10.0.0.0/16"
        gateway_id           = "local"
    }
}

resource "aws_security_group" "sg_main_1" {
    vpc_id                   = aws_vpc.production_vpc.id

    ingress {
        description          = "allow ping to all instances"
        from_port            = 8
        to_port              = 0
        protocol             = "icmp"
        cidr_blocks          = ["0.0.0.0/0"]

    }
    ingress {
        description          = "allow ssh connectivity to vpc"
        from_port            = 22
        to_port              = 22
        protocol             = "tcp"
        cidr_blocks          = ["0.0.0.0/0"]
    }
    ingress {
        description          = "allow HTTP connectivity to vpc"
        from_port            = 80
        to_port              = 80
        protocol             = "tcp"
        cidr_blocks          = ["0.0.0.0/0"]
    }
    egress {
        description          = "Allow all exit traffic"
        from_port            = 0
        to_port              = 0
        protocol             = "-1"
        cidr_blocks          = ["0.0.0.0/0"]
    }
 }

resource "tls_private_key" "this" {
    count                    = 2
    algorithm                = "RSA"
    rsa_bits                 = 2048
}

resource "aws_key_pair" "backend_key_pair" {
    count                    = 1
    key_name                 = "backend_public_key"
    public_key               = trimspace(tls_private_key.this[0].public_key_openssh)
}

resource "aws_key_pair" "frontend_key_pair" {
    count                    = 1
    key_name                 = "frontend_public_key"
    public_key               = trimspace(tls_private_key.this[1].public_key_openssh)
}

resource "aws_instance" "ec2_backend_instance" {
    ami                      = "ami-04e601abe3e1a910f"
    instance_type            = "t2.micro"
    availability_zone        = "eu-central-1a"
    subnet_id               = aws_subnet.subnet_backend.id
    security_groups         = [aws_security_group.sg_main_1.id]
    key_name                 = aws_key_pair.backend_key_pair[0].key_name
}

resource "aws_instance" "ec2_frontend_instance" {
    ami                      = "ami-04e601abe3e1a910f"
    instance_type            = "t2.micro"
    availability_zone        = "eu-central-1a"
    subnet_id               = aws_subnet.subnet_frontend.id
    security_groups         = [aws_security_group.sg_main_1.id]
    key_name                 = aws_key_pair.frontend_key_pair[0].key_name
}
