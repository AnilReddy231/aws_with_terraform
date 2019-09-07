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
        map("Name", "${var.ansible_dns}${count.index}")
    )}"
}