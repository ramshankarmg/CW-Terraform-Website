#CREATE THE USER-DATA FILE FOR INSTALLING THE APP
data "template_file" "userdata" {
  template = "${file("../app_setup/userdata.sh")}"

  vars = {
    DB_NAME                             = "${var.db_dbname}"
    DB_USER                             = "${var.rds_username}"
    DB_PASSWORD                         = "${var.rds_password}"
    DB_HOST                             = "${var.rds_host}"
  }
}

resource "aws_launch_configuration" "autoscale_launch" {
  image_id = "${var.aws_image_id}"
  instance_type = "${var.instance_type}"
  security_groups = ["${var.ec2_sg_id}"]
  key_name = "${var.key_name}"
  user_data = "${data.template_file.userdata.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = "${aws_launch_configuration.autoscale_launch.id}"
  vpc_zone_identifier = ["${var.private_subnet_a_id}", "${var.private_subnet_b_id}"]
  load_balancers = ["${aws_elb.elb.name}"]
  min_size = "${var.asg_min_size}"
  max_size = "${var.asg_max_size}"
  tag {
    key = "Name"
    value = "${var.owner}-${var.env}-${var.app}"
    propagate_at_launch = true
  }
}

resource "aws_elb" "elb" {
  name = "${var.owner}-${var.env}-${var.app}-elb"
  security_groups = ["${var.elb_sg_id}"]
  subnets            = ["${var.public_subnet_a_id}", "${var.public_subnet_b_id}"]
  cross_zone_load_balancing   = true
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}

#CREATE SNS TOPIC FOR ASG ALARM 
resource "aws_sns_topic" "sns-topic" {
  name = "${var.owner}-${var.env}-${var.app}-sns"
}

# Auts Scaling Policy
resource "aws_autoscaling_policy" "asg-policy-scale-up" {
  policy_type               = "StepScaling"
  name                      = "${var.owner}-${var.env}-${var.app}-asg-policy-scale-up"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = "${aws_autoscaling_group.asg.name}"
  estimated_instance_warmup = "60"

  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 0
  }
}

resource "aws_autoscaling_policy" "asg-policy-scale-down" {
  policy_type              = "StepScaling"
  name                     = "${var.owner}-${var.env}-${var.app}-asg-policy-scale-down"
  adjustment_type          = "PercentChangeInCapacity"
  autoscaling_group_name   = "${aws_autoscaling_group.asg.name}"
  min_adjustment_magnitude = "1"

  step_adjustment {
    scaling_adjustment          = -25
    metric_interval_upper_bound = 0
  }
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "alarm-cpu-high" {
  alarm_name          = "${var.owner}-${var.env}-${var.app}-alarm-cpu-high"
  alarm_description   = "${var.owner}-${var.env}-${var.app}-alarm-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.asg-policy-scale-up.arn}", "${aws_sns_topic.sns-topic.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "alarm-cpu-low" {
  alarm_name          = "${var.owner}-${var.env}-${var.app}-alarm-cpu-low"
  alarm_description   = "${var.owner}-${var.env}-${var.app}-alarm-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.asg-policy-scale-down.arn}", "${aws_sns_topic.sns-topic.arn}"]
}

resource "aws_autoscaling_notification" "autoscaling-notification" {
  group_names = [
    "${aws_autoscaling_group.asg.name}",
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = "${aws_sns_topic.sns-topic.arn}"
}