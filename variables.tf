variable "region" {
   default = "us-east-1"
}

variable "profile" {
   default = "student.3"
}

variable "ami" {
  default = "ami-084568db4383264d4"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "webserver_prefix" {
default = "student.3-webserver-vm"
}
variable "loadbalancer_prefix" {
default = "student.3-loadbalancer-vm"
}

variable "web_docker_host_prefix" {
default = "student.3-docker-vm"
}

variable "lb_docker_host_prefix" {
  default = "student.3-lb_docker_host-vm"
}