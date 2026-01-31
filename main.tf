terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 5.0"
   }
 }
}


provider "aws" {
 region = var.aws_region
}


data "aws_iam_instance_profile" "labrole" {
 name = "LabInstanceProfile"
}


resource "aws_ecr_repository" "app" {
 name                 = "clo835-app"
 image_tag_mutability = "MUTABLE"
 force_delete         = true
}


resource "aws_ecr_repository" "mysql" {
 name                 = "clo835-mysql"
 image_tag_mutability = "MUTABLE"
 force_delete         = true
}




resource "aws_security_group" "app_sg" {
 name        = "clo835-app-sg"
 description = "Allow SSH and App traffic"


 ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }


 ingress {
   from_port   = 8081
   to_port     = 8083
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




resource "aws_instance" "app" {
 ami                    = var.ami_id
 instance_type          = "t2.micro"
 key_name               = var.key_name
 vpc_security_group_ids = [aws_security_group.app_sg.id]


 iam_instance_profile = data.aws_iam_instance_profile.labrole.name


 user_data = <<-EOF
   #!/bin/bash
   yum update -y
   yum install -y docker
   systemctl start docker
   systemctl enable docker
   usermod -aG docker ec2-user
 EOF


 tags = {
   Name = "clo-app"
 }
}

