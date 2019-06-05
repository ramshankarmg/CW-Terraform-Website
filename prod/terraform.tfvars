#AWS variables
access_key = ""
secret_key = ""
region = ""

# Tags
#there is a bug in terraform 0.2 where if these variable is in CAPS causes it to fail on "aws_db_subnet_group" type resource.
#Didn't get much time to debug on it. For now keep them lowercase or sanitize these variables before passing to terraform
owner = "cwtest"
env = "prod"
app = "phpapp"

#RDS
rds_instance_type = "db.t2.small"
rds_allocated_storage = "50"
rds_engine_type = "mysql"
rds_engine_version = "5.6.43"
rds_multi_az = "true"

#APP
#Ubuntu 18.0 is required. Can set specific ami here else "aws_ami" data will fetch the right one depending on the region in prod/main.tf
aws_image_id = ""
ec2_instance_type = "t2.micro"

#ASG
asg_min_size = "1"
asg_max_size = "3"