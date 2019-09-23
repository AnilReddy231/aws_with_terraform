locals {
  ssh_key_file = "${path.module}/keypair/${aws_key_pair.generated_key.key_name}.pem"
}

data "template_file" "file_import_ansible" {
  template = "${file("${path.module}/default.tpl")}"

  vars = {
    tag_name             = "${var.ansible_dns}"
  }
}

data "template_cloudinit_config" "render_parts_ansible" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "user_data.sh"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.file_import_ansible.rendered}"
  }
}

resource "local_file" "ssh_key_private" {
  sensitive_content  = "${tls_private_key.ssh.private_key_pem}"
  filename           = "${local.ssh_key_file}"

  provisioner "local-exec" {
    command = "chmod 600 ${file(local.ssh_key_file)}"
  }
}

resource "aws_instance" "ansible" {
    count                  = "${var.slave_count}"
    ami                    = "${lookup(var.instance_ami_map, var.region)}"
    instance_type          = "${var.ansible_instance_size}"
    vpc_security_group_ids = ["${var.sg_id}"]
    source_dest_check      = false
    subnet_id              = "${var.subnet_id}"
    key_name               = "${aws_key_pair.generated_key.key_name}"
    user_data              = "${data.template_cloudinit_config.render_parts_ansible.rendered}"
    associate_public_ip_address = true
    
    root_block_device {
        volume_type = "gp2"
    }

    tags = "${merge(var.tags,
        map("Name", "${var.ansible_dns}${count.index}"),
        map("Type","Ansible")
    )}"
}

resource "null_resource" "python3" {
  count = "${var.slave_count}"
  depends_on = [aws_instance.ansible]
  triggers = {
    instance_id = "${aws_instance.ansible[count.index].id}"
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file(local.ssh_key_file)}"
    host = "${aws_instance.ansible[count.index].public_ip}"
    timeout = "300s"
    }

  provisioner "remote-exec" {
    inline = ["ls -ltr", "sudo yum install python36 python36-devel python36-libs python36-tools -y"]
  }
}

resource "null_resource" "install_java" {
  count = "${var.slave_count}"
  provisioner "local-exec" {
      command = <<EOT
        >java.ini;
        echo "[java]" | tee -a java.ini;
        echo "${aws_instance.ansible[count.index].public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${pathexpand(local.ssh_key_file)}" | tee -a java.ini;
        export ANSIBLE_HOST_KEY_CHECKING=False;
        export ANSIBLE_LOG_PATH=ansible_java.log;
        ansible-playbook -u ${var.ansible_user} --private-key ${pathexpand(local.ssh_key_file)} -i java.ini playbooks/install_java.yml;
        sleep 30;
      EOT
    }
}

resource "null_resource" "install_jenkins_ci" {
  count = 1
  provisioner "local-exec" {
      command = <<EOT
        >jenkins.ini;
        echo "[jenkins]" | tee -a jenkins.ini;
        echo "${aws_instance.ansible[0].public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${pathexpand(local.ssh_key_file)}" | tee -a jenkins.ini;
        export ANSIBLE_HOST_KEY_CHECKING=False;
        export ANSIBLE_LOG_PATH=ansible_jenkins.log;
        ansible-playbook -u ${var.ansible_user} --private-key ${pathexpand(local.ssh_key_file)} -i jenkins.ini playbooks/install_jenkins.yml;
        sleep 30;
      EOT
    }
}

resource "null_resource" "install_gitlab_ce" {
  count = 1
  provisioner "local-exec" {
      command = <<EOT
        >gitlab.ini;
        echo "[gitlab]" | tee -a gitlab.ini;
        echo "${aws_instance.ansible[1].public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${pathexpand(local.ssh_key_file)}" | tee -a gitlab.ini;
        export ANSIBLE_HOST_KEY_CHECKING=False;
        export ANSIBLE_LOG_PATH=ansible_gitlab.log;
        ansible-playbook -u ${var.ansible_user} --private-key ${pathexpand(local.ssh_key_file)} -i gitlab.ini playbooks/install_gitlab.yml;
        sleep 30;
      EOT
    }
}