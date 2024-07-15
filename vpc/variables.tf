variable "vpc_name" {
}

variable "cidr_numeral" {
}

variable "availability_zones" {
  type = list(string)
}

variable "short_azs" {
  type = list(string)
}

variable "cidr_numeral_public" {
}

variable "cidr_numeral_private_was" {
}

variable "cidr_numeral_private_db" {
}
