terraform {
    required_version = ">=0.11.1"
}

variable "public_key_path" {
    default = "/Users/uprince/Downloads/bitnami-wordpress-key.pem"
}

variable "key_name" {
    default = "bitnami-wordpress-key"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "image_id" {
    default = "ami-0c96cc94f7c626acf"
}