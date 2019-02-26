## JobApplication HomeWork
--------------

#### about of project
writed for job application homework.
this homework mainly test your devops and learning skills.
keywords: terraform, aws, ansible

License GNU GPL v3


#### targets
* all project objects must run on the aws
* wordpress must run on  aws Ec2
* there must be have load balancer in front of server
* database must be aws Rds

#### pre Requirements

* [Terraform](https://www.terraform.io/downloads.html)
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* Amazon Aws Key(ec2)
* Amazon Aws IAM(AdminAccess)

##### Topology

![alt text][logo]

[logo]: https://raw.githubusercontent.com/ysfduzgun/devopsHw/master/pictures/network.png "network"

#### Lets start

#### s1- first clone project
```sh
git clone https://github.com/ysfduzgun/devopsHw
```
#### s2- Edit credential file - (Aws AIM)
```sh
devopsHw/terraform/credential
```
#### s3- Copy your pem and change perm. - (AWS ec2Key)
```sh
cp your_key.epm devopsHw/ansible/your_key.pem
chmod 400 devopsHw/ansible/your_key.pem
```
#### s4- Terraform stage
```sh
cd devopsHw/terraform/
terraform init
terraform plan
terraform apply
yes
```
now our architecture is preparing. we can check server with ping.
```sh
ping $(terraform output ubuntuIp)
```
when server answer to request we can go next step.

we must solve ssh fingerprint ask problem

- connect to server with ssh
```sh
cd devopsHw/ansible
ssh -i your_key.pem ubuntu@ip
The authenticity of host 'ip (ip)' can't be established.
ECDSA key fingerprint is SHA256:xyzxyzxyzxyzxyzxyzxyzxyzxyz.
Are you sure you want to continue connecting (yes/no)? yes
exit
```
- or disable check
```sh
touch ~/.ssh/config
echo "Host *" > ~/.ssh/config
echo "    StrictHostKeyChecking no" >> ~/.ssh/config
```

#### s5- preInstall wp environment and get some variables for ansible.
```sh
cd devopsHw/terraform
./preAnsible.sh
```

#### s6- install all wp environment and configure them
```sh
cd devopsHw/ansible/
ansible-playbook playbook.yml -i hosts.inf --private-key=./your_key.pem
```
#### sFinal-
lets request ip:6868 port, loadbalancer should have redirect to server:80
```sh
cat devopsHw/terraform/elbIp.txt
```

![alt text][logo2]

[logo2]: https://raw.githubusercontent.com/ysfduzgun/devopsHw/master/pictures/final.png "final"

#### delete everything
```sh
cd devopsHw/terraform
terraform destroy
```
--------------
