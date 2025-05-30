resource "aws_instance" "my_vm" {
  count                  = var.instance_count
  ami                    = var.ami
  subnet_id              = var.subnet_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = var.tags

  provisioner "remote-exec" {
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      agent       = false
      private_key = file("../keys/student.3-vm-key")
    }

    inline = [
      "sudo apt update -y",
      "sudo apt install -y python3"
    ]
  }
}

resource "local_file" "tf_ansible_inventory" {
count = length(aws_instance.my_vm)>0 ? 1 : 0
content = <<-EOT
[${var.install_package}]
%{ for vm in aws_instance.my_vm.* ~}

${vm.private_dns} ansible_host=${vm.public_ip} ansible_ssh_user=ubuntu
%{ endfor ~}
EOT
filename = "./tf_ansible_${var.install_package}_inventory.ini"
}

resource "time_sleep" "wait_30_seconds" {
depends_on = [aws_instance.my_vm]
count = length(aws_instance.my_vm)>0 ? 1 : 0
create_duration = "30s"
}

resource "null_resource" "install_package" {
  count = length(aws_instance.my_vm) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = <<EOT
      ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook \
        -u root \
        -i ./tf_ansible_webservers_inventory.ini \
        /home/anuj/terraform_base/ansible_playbooks/apache-install.yml \
        --private-key ../keys/student.3-vm-key
    EOT
  }

  depends_on = [aws_instance.my_vm]
}
