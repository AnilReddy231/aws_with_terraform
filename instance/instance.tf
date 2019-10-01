data "template_file" "file_import" {
  template = "${file("${path.module}/default.tpl")}"

  vars = {
    rootUserPassword     = "${random_string.rootUserPassword.result}"
    monitorUserPassword  = "${random_string.monitorUserPassword.result}"
    tag_name             = "${var.controller_dns}"
  }
}

data "template_cloudinit_config" "render_parts" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "user_data.sh"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.file_import.rendered}"
  }
}

resource "aws_instance" "ansible_controller" {
  ami                    = "${lookup(var.instance_ami_map, var.region)}"
  instance_type          = "${var.ansible_instance_size}"
  vpc_security_group_ids = ["${var.sg_id}"]
  source_dest_check      = false
  subnet_id              = "${var.subnet_id}"
  key_name               = "${aws_key_pair.generated_key.key_name}"
  user_data              = "${data.template_cloudinit_config.render_parts.rendered}"
  associate_public_ip_address = true
  
  root_block_device {
    volume_type = "gp2"
  }

  tags = "${merge(var.tags,
    map("Name", "${var.controller_dns}"),
    map("Type", "Controller")
  )}"
}