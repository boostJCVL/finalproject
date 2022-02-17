variable "vpc_id" {
    type = string 
}

variable "priv_subnets" {
    type = list(string)
}

variable "clustername" {
    type = string
}

variable "ecs_role1" {
    type = string
}

variable "min" {
    type = number
}

variable "max" {
  type        =  number
}

variable "desired" {
  type        =  number
}

variable "autoscaleTG" {
    type = string
}

variable "autoscaleTGG" {
    type = string
}