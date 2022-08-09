# Terraform-Task
# About this repo
A Terraform that creates a complete environment with the following configuration: VPC, 2 Subnets: a Private and the second one is public, Internet Gateway, NAT Gateway, Route Tables, Route Tables Associations, Create and run an instance with WordPress installed on the public subnet, Create and run an instance with MySQL installed on the private subnet.<br>
# Prerequirements
1- In AWS IAM, I Created a User with AdministratorAccess policy.<br>
2- Connect to my aws account with the command: aws configure, to provide the access key and the secret key.<br>
# Run with Terraform
