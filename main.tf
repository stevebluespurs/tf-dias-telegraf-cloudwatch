# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
  #version = "~> 2.0"
  #convert to role arn
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

#use module
module "telegraf" {
  source = "./telegraf"
  pvt_key = "${var.pvt_key}"
  ssh_ip = "${var.ssh_ip}"
  num_srvrs = "${var.num_srvrs}"
}
