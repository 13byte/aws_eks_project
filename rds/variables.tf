variable "vpc_id" {

}

variable "vpc_name" {
  type = string
}

variable "root_username" {
  type = string
}

variable "root_password" {
  type = string
}

variable "init_db_name" {
  type = string
}

variable "db_subnet" {
  type = list(string)
}

variable "additional_ingress" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    security_groups = list(string)
  }))
  default = []
}
