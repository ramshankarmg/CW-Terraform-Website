# Overview

This codebase creates a HA cluster for a simple [php application](https://github.com/xxxVxxx/crud-php-simple) on AWS using Terraform. In addition to being HA the infra is also scalable and uses RDS for its database. The RDS is also setup in HA mode via *multi-az* setup.
The codebase has been broken down at 3 levels so that component re-use is maximum. This is covered later in the section.
Given the limited time to finish this project, there are quite some improvements that can be taken up in the next iteration. These improvement ideas are also covered later on so that it can be taken up in the next cycle of development.

## Requirements
1.  AWS Account
2.  IAM User with admin privileges
3.  Access key/Secret Key
4.  Terraform installed. Version 0.12 and over as older versions might not work.
5.  ssh public key in `~/.ssh/id_rsa`

## How to use:
* Make sure you meet all the requirements mentioned above.
* Clone this repo
  ```
  git clone https://github.com/xxxVxxx/CW-Terraform-Website.git
  ```
* Export required env variables
  The AWS access key , access key secret and region needs to be exported as env variables so that you dont put sensitive data into terraform files, which might end up on github.
  ```
  $ export AWS_ACCESS_KEY_ID="accesskey"
  $ export AWS_SECRET_ACCESS_KEY="asecretkey"
  $ export AWS_DEFAULT_REGION="ap-southeast-1"
  ```

* Change config as per requirement.<br>
  The top level code base is located in the **prod** folder. To deploy this code, do the following:
  ```
  cd CW-Terraform-Website/prod
  ```
  Change the config variables located in **terraform.tfvars**
  ```
  vim terraform.tfvars
  ```
  Here you can modify things like the **tags** used for creaton of infrastructure, **rds** settings, **ec2** instance size,etc. The EC2 image required is **ubuntu 18.0**. Unless there is a need for a specific ami, leave it empty as the terrform code will figure the right ami depending upon the region its being deployed. If the **aws_image_id** is set, then it will override it.

* Dont keep custom passwords unless required.<br>
  Unless you are not very particular about using a certain password for RDS admin database user, you do not need to modify anything much as this code will generate random password and print it out at the end. This avoids using hard-coded passwords for environments,especially testing, which can later leak and cause problems.

* Do the terraform thing.<br>
  Go to the environment directory and run the terraform commands.For example lets do it in prod
  ```
  $ cd CW-Terraform-Website/prod
  $ terraform init
  $ terraform plan
  $ terraform apply
  ```
* Save the output<br>
  The output will contain all the required information for your consumption. An example of the same is as below:
  ```
  bastion_public_ip = 13.250.16.94
  elb-endpoint = cwtest-prod-phpapp-elb-695048271.ap-southeast-1.elb.amazonaws.com/crud-php-simple
  myip = 171.76.119.133/32
  rds-endpoint = cwtest-prod-phpapp.cxdtr3gh99df.ap-southeast-1.rds.amazonaws.com
  rds-password = l5M0MtGKya
  rds-username = admin
  ssh-user = ubuntu
  vpc-id = vpc-00615d0822e744847
  ```

* Visit the application site using the `elb-endpoint` location.<br>
  For the first launch it might take a bit of time before the php application is up as the userdata running on the EC2 instance can take time to finish. Make sure the php EC2 instance is fullly up and running and not in initialising stage.

## Code Structure
The code base is logically broken at 3 layers. At the core layer is the `modules` folder which contains all the different modules that we will use for aws infrastructure. These are broken into folders according to the functionality they provide. example rds, subnet, vpb_base, etc.<br>
At the next level we will break the code base into `cluster_setup` `database_setup` `sg_setup` and `app_setup`.Each of these folders do independently what is required out of them. This gives us the freedom to test them individually and also spin up multiple clusters just by using this layer.Each layer can be independently updated for further use case.<br>
`cluster_setup`: setups the base infra for use. That will include vpc, subnets, internet-gateway, nat-gateway,etc<br>
`sg_setup`: this creates all the required security groups for this particular setup.<br>
`database_setup`: this will setup the rds with the required configuration.<br>
`app_setup`: currently due to lack of time, this code base is not broken further into individual `modules` but for this use case it creates all the required things to run the app. This will include the auto-scaling group, cloudwatch alarms, auto-scaling group, launch configuration, elb, sns topic,auto-scaling notifications, auto scaling policies.<br>
At the top level comes the `prod` folder that contains the high level configurations for depoying this particular environment which in turn depend on the above two layers.


## Infra-structure Created with this module
Following things will be created when this terraform module is used.
* 1 VPC.
* 4 SUBNETS; 2 Public subnets and 2 Private subnets across 2 AZ's.
* 1 Internet Gateway.
* 2 Nat Gateways, one each in the subnet.
* 3 Route tables; 2 Private and 1 Public.
* 4 Security groups.
* 1 RDS cluster in Multi-AZ.
* 1 RDS subnet group.
* 1 Auto-scaling group.
* 1 Launch configuration.
* 1 ELB.
* 1 SNS Topic.
* 2 Auto-scaling policies. 1 for scale-up and 1 for scale-down.
* 2 Cloudwatch alarms.
* 1 Auto-scaling notification group.
* 1 bastion host to connect to the ec2 instances launched in private.

The ELB is created in the public subnet and the EC2 instances and the RDS  are created in the private subnet. Autoscaling group is attached to the ELB in the public subnet and talks to the EC2 instnaces in the private subnet thereby reducing the exposure to the instances from outside world. To help debug issues, we need another machine that is publicly accessible. For that we create a bastion EC2 instance that is launched in public subnet and to further reduce the attack surface on ssh I have made sure that the ssh is only open from the machine from which the terrform code is launched. This information is gathered from terrafrom itself and is dynamic.This is obtained using the below terraform code:
```

data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}
```
The key-pair created for accessing the instances are done using the public key stored in `~/.ssh/id_rsa` file. This eases deployment for dev environments and for production its advisable to use a dedicated machine for launching terraform.But for testing same environment is sufficient.
If you want to change the public key used for ssh then you need to change this part of code in `prod/main.tf` file:
```
data "template_file" "ssh_public_key" {
  template = "${file("~/.ssh/id_rsa.pub")}"
}

```
The password generated for rds is random and done using the code snippets below:
```
resource "random_string" "rds_password" {
  length  = 10
  special = false
}
```
This removes the requirement to use hard-coded passwords.

The app deployment is done using `userdata.sh` file which is located in the `app_setup` folder . This file takes care of making sure the rds instance is up before going further with the install, making sure to skip database creation if database already exists.This is important as this userdata is tied up with all EC2 instances launched in auto-scaling group and can fail if database already exists; which will be the case when the first EC2 instnace is created.
It also creates the `config.php` file dynamically using all the required rds details.
Finally one can access the app using the ELB endpoint, the id of which is given out with terraform output.

## Improvements - Short Term
* The code base in `app_setup` is not segregated for each individual module like elb, auto-scaling,etc. These individual modules needs to be created in `modules` folder and invoked as with other modules like rds,subnet,vpc,etc
* The source file is used as `source = "../modules/<module_name>"`.This can be improved by `"git::https://github.com/xxxVxxx/CW-Terraform-Website/modules/<module_name>.git?ref=v1.2.0"`. This way we can do independant code module update and tag them for specific use case across all modules
* Use `terraform remote backend`. Presently all the senstive data from terraform creation are stored locally. This is a big **NO-NO** for production setup. This should be done via using a remote storage, either S3 or consul. But there is a chicken and egg problem with this as the S3 bucket needs to be created before hand. And since validation of the unique-ness would require time, I have omitted using it for this example. This can also be done later once terraform is run and s3 bucket is created by using `terraform push state`.
* Move terraform lock file to dynamodb so that there is a better locking on it when multiple developers work on it.
* Create the required DNS entries using route53. Presently I have not implemented creating Route53 entries but this is important for real live production.
* SSL certificates for production environment and ssl termination at ELB
* Write README files for each of the modules and each of the setup layers to better understand how to use them indpendently.


## Improvements - Long Term
* For betterment of production environment, there is almost always some static content. To better serve them, we need to make use of CloudFront so that it does not cause load on the frontend servers.
* In this example, we are creating the config from userdata. When apps scale and multiple environment requirements come into play , this method is very rigid and problematic. The best way would be to utilize a consul service and installation of consul agent on each server that will pull the required config for the app.This helps clearly segregate code from config. To make it secure, we can also use `kms` or `hashicorp vault` to keep secrets encrypted.
* This application directly does operations with database. In production this can be a problem as database can un-necessarily be hit with same queries. This can be solved by using a caching layer using either Redis or memcache. This way the hits to same queries can be greatly reduced to the database. Caching layers also can be a cause of bottleneck. To overcome such cases, circuit-breaker logic with exponential  backoff should be implemented in the application.
* Look at tools like `terragrunt` `terratest` for further increasing the modularity of the code and for better testing
* Remove app deployment out of terraform and make it independant. Infrastructre code and deployment methodology should not be so tightly coupled as it will cause a lot of problems when we scale.







