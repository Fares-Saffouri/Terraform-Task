# Terraform-Task
# About this repo
A Terraform that creates a complete environment with the following configuration: VPC, 2 Subnets: a Private and the second one is public, Internet Gateway, NAT Gateway, Route Tables, Route Tables Associations, Create and run an instance with WordPress installed on the public subnet, Create and run an instance with MySQL installed on the private subnet.<br>
# Prerequirements
1- In AWS IAM, I Created a User with AdministratorAccess policy.<br>
2- Connect to my aws account with the command: aws configure, to provide the access key and the secret key.<br>
# Run with Terraform
1- git clone https://github.com/Fares-Saffouri/Terraform-Task.git<br>
2- cd Terraform-Task<br>
3- terraform init<br>
4- terraform apply<br>
5- to delete the resources: terraform destroy<br>
<br>
<img src="https://user-images.githubusercontent.com/70641137/183703766-0a74625a-bf65-4970-9233-82b92454d44e.png" width="900" height="400">
<br><br>
<img src="https://user-images.githubusercontent.com/70641137/183703870-969451fa-d91e-4b3b-845c-ad615f474304.png" width="700" height="200">
<br><br>
<img src="https://user-images.githubusercontent.com/70641137/183703888-34f755ef-c8fc-495d-98bb-fdd04012f30b.png" width="700" height="200">
<br><br>
<br><br>
<img src="https://user-images.githubusercontent.com/70641137/183703909-41cb2e34-a1a0-4f24-beca-7782a8602788.png" width="700" height="200">
<br><br>
<br><br>
<img src="https://user-images.githubusercontent.com/70641137/183703944-0c476572-7c0c-4038-9162-d5f8e6f67398.png" width="700" height="200">
<br><br>

