data "terraform_remote_state" "network_details" {
backend = "s3"
config = {
bucket = "anuj-bucket-2025"
key = "student.3-network-state"
region = "us-east-1"
}
}

resource "aws_instance" "my_vm" {
ami = "ami-084568db4383264d4"
instance_type = "t3.micro"
subnet_id =data.terraform_remote_state.network_details.outputs.my_subnet
key_name = data.terraform_remote_state.network_details.outputs.my_aws_key_pair

tags = {
Name = "student.3-vm1"
}
}
