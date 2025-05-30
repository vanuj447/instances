data "terraform_remote_state" "network_details" {
backend = "s3"
config = {
bucket = "anuj-bucket-2025"
key = "student.3-network-state"
region = var.region
}
}

resource "aws_instance" "my_vm" {
ami = "ami-084568db4383264d4"
instance_type = "t3.micro"
subnet_id =data.terraform_remote_state.network_details.outputs.my_subnet
key_name = data.terraform_remote_state.network_details.outputs.my_aws_key_pair
vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
tags = {
Name = "student.3-vm1"
}
}
