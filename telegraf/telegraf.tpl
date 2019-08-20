#!/bin/bash

#log the output of this script here
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
echo "export PATH=~/.local/bin:$PATH" >> ~/.bash_profile
source ~/.bash_profile
pip --version
pip install awscli --upgrade --user

yum install -y vim mlocate
updatedb

cat <<EOF | tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOF

yum install telegraf -y
service telegraf start

telegraf config > telegraf.toml

#Check if cloudwatch logs are avaialble
#aws cloudwatch list-metrics --namespace AWS/ES --region us-east-2

#config to check all pulled data from CW
cat <<EOF | tee telegraf_cw.toml

[[inputs.cloudwatch]]
  region = "${region}"
  period = "2m" #aggregation period start-end time
  delay = "2m" #delay to allow metric availability on CW
  interval = "2m" #multiple of period; how freqent to collect
  namespace = "AWS/ES"
  ratelimit = 10 #numberof req per sec
  statistic_include = ["average"]
  [[inputs.cloudwatch.metrics]]
    names = ["ClusterStatus.green", "2xx", "3xx", "4xx", "5xx", "ClusterStatus.yellow", "ClusterStatus.red"]
    [[inputs.cloudwatch.metrics.dimensions]]
        name = "DomainName"
        value = "*"
    [[inputs.cloudwatch.metrics.dimensions]]
        name = "ClientId"
        value = "*"

[[outputs.influxdb]]
  urls = ["http://${influxdb}"]
  database = "${database}"

EOF

#Check if telegraf is able to get the cloud watch logs (test)
telegraf --config telegraf_cw.toml --test #--input-filter cloudwatch
