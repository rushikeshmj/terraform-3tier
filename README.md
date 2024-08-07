TERRAFORM – POC
Installing aws cli and configuring
AWS configure
Providing credentials region and output types
1.	Create Two Resources in Different Regions
Here’s how you can create two resources, such as EC2 instances, in different regions
Provider.tf

 

Main.tf
 
 

 

 

 




Successfully created resources within two different regions
 

 

2.	Perform state lock
Creating S3 bucket
 

Creating dynamoDB table
 
Initializing backend to store state
 

 


 

created new terraform project state lock  with similar codes and Backend to store statefile
 

 

 

3.	Create 3 identical resources with different name using loops.
provider.tf: Configures the AWS provider with the desired region i.e “us-east-1”
 


main.tf:
a.	variable "instance_count": Defines the number of instances to create.
b.	variable "instance_names": Defines the names for each instance.
c.	resource "aws_instance" "example": Uses the count meta-argument to create multiple instances. The count.index is used to index into the instance_names variable to assign unique names.
 









outputs.tf:
output "instance_ids": Outputs the IDs of the created instances.
output "instance_public_ips": Outputs the public IP addresses of the created instances.
 

successfully executing following commands
Terraform init-
 


Terraform plan
 
Terraform apply with outputs
 







4.	Deploy 3-tier application using terraform

a.	Set up environment: Install Terraform and AWS CLI.
b.	Create directory structure: Organize Terraform files.
 

c.	Write configuration: Define provider, variables, resources, and outputs.

 
 

 

d.	Initialize and apply: Use Terraform commands to deploy and verify resources.
 

 

 



e.	Copy LB dns and hit 
http://main-lb-1928893195.us-east-1.elb.amazonaws.com/
 

f.	Clean up: Destroy resources when no longer needed.
 





