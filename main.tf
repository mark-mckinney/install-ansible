//NOTE: Please complete variables before running.

//Access AWS account services
provider "aws" {
    region = "us-east-2"
    access_key = var.access_key
    secret_key = var.private_key
}

//Creates Ubuntu Server
resource "aws_instance" "ansible-server-instance" {
  ami = "ami-00399ec92321828f5"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  vpc_security_group_ids = [aws_security_group.allow_ssh_access.id]
  key_name = var.ssh_key_name

  associate_public_ip_address = true

  tags = {
    "Name" = "Ansible-server"
  }
}

//Makes connection to new Ubuntu server via ssh and installs Ansible, Git, and clones a repo
resource "null_resource" "install-ansible" {
  connection {
    type = "ssh"
    host = aws_instance.ansible-server-instance.public_ip
    user = "ubuntu"
    private_key = file("${path.module}/key/${var.ssh_key_name}.pem")
  }

  provisioner "remote-exec" { 
        inline = [
          "sudo apt update",
          "sudo apt install software-properties-common -y",
          "sudo add-apt-repository --yes --update ppa:ansible/ansible",
          "sudo apt install ansible -y",
          "sudo apt install git-core",
          "sudo mkdir git_environment",
          "cd git_environment",
          "sudo git clone ${var.clone_git_repo_link}",
          "ansible --version",
          "git --version"
        ]
  }

  depends_on = [ aws_instance.ansible-server-instance ]
}

//Creates security group to allow ssh access
resource "aws_security_group" "allow_ssh_access" {
  name = "allow_ssh_traffic"
  description = "Allow SSH Traffic"

  ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "allow_ssh_connection"
  }
}


output "public_ip" {
  value = aws_instance.ansible-server-instance.public_ip
}

//change dir to "key" directory where .pem file is located & Copy the output link into console for quick ssh connection
output "ssh_connetion" {
  value = "ssh -i ${var.ssh_key_name}.pem ubuntu@${aws_instance.ansible-server-instance.public_dns}"
}



