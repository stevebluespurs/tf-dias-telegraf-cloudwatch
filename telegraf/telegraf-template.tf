data "template_file" "telegraf" {
    template = "${file("./telegraf/telegraf.tpl")}"
    vars = {
        region = "${var.region}"
        influxdb = "${var.influxdb}"
        database = "${var.database}"
    }
}
