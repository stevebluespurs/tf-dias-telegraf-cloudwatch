variable "num_srvrs" {}
variable "pvt_key" {}
variable "ssh_ip" {}

variable "region" {
  default = "us-east-2"
}

variable "instance_type" {
  default = "m5.2xlarge"
}

variable "influxdb" {
  default = "{{stats.url}}:{{stats.port}}"
}

variable "database" {
  default = "ingestor_{{stats.db}}"
}

variable "security_group" {
  default = [""]
}

variable "vpc_id" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

variable "instance_name" {
  default = "telegraf-test"
}
