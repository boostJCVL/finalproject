variable "vpc_id" {
    type = string 
}

variable "pub_subnets" {
    type = list(string)
}

variable "security_group" {
    type = string
}

