data "terraform_remote_state" "network_details" {
backend = "s3"
config = {
bucket = "anuj-bucket-2025"
key = "student.3-network-state"
region = var.region
}
}

module "webserver" {
source = "./modules/linux_node"
ami = var.ami
instance_count = "0"
instance_type = var.instance_type
key_name = data.terraform_remote_state.network_details.outputs.key_name
subnet_id = data.terraform_remote_state.network_details.outputs.my_subnet
vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
tags = {
Name = var.webserver_prefix
}
install_package = "webservers"
playbook_name = "apache-install.yml"
}


module "web_docker_host" {
source = "./modules/linux_node"
ami = var.ami
instance_count = "1"
instance_type = var.instance_type
key_name = data.terraform_remote_state.network_details.outputs.key_name
subnet_id = data.terraform_remote_state.network_details.outputs.my_subnet
vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
tags = {
Name = var.web_docker_host_prefix
}
install_package = "dockerhost"
playbook_name = "install-docker.yaml"
}
