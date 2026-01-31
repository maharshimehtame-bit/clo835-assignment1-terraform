variable "aws_region" {
 default = "us-east-1"
}


variable "ami_id" {
 description = "Amazon Linux 2023 AMI ID"
 default     = "" # add yours chief
}


variable "key_name" {
 description = "SSH key pair name"
}
