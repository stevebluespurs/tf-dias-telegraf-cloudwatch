resource "aws_instance" "telegraf" {
  ami = "${data.aws_ami.centos.id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.pvt_key}"
  subnet_id = "${var.subnet_id}"
  security_groups = "${var.security_group}"
  user_data = "${data.template_file.telegraf.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.telegraf_cw_profile.name}"

  tags = {
    Name = "${var.instance_name}"
  }
}
