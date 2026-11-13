data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ubuntu_2204.id
  instance_type               = var.jenkins_instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.jenkins_host.id]
  key_name                    = var.ssh_key_name
  iam_instance_profile        = aws_iam_instance_profile.jenkins_host.name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-jenkins-host"
  }
}
