variable "region" {
  default = "eu-west-1"
  type = string
}
variable "container_name" {
  default = "goapi"
  type = string
}
variable "container_image" {
  default = "nginx:latest"
  type = string
}
variable "container_port" {
  default = 8080
  type = number
}