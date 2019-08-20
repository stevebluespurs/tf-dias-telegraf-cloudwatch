resource "aws_iam_role" "telegraf_cw_role" {
  name = "telegraf_cw_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "TelegrafCloudWatchRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "telegraf_cw_profile" {
  name = "telegraf_cw_profile"
  role = "${aws_iam_role.telegraf_cw_role.name}"
}

resource "aws_iam_role_policy" "telegraf_cw_policy" {
  name = "telegraf_cw_policy"
  role = "${aws_iam_role.telegraf_cw_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "TelegrafCloudWatchPolicy"
    }
  ]
}
EOF
}
