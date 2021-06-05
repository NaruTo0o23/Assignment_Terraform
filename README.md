# Assignment_Terraform <br />
Assignment given to perform a task using terraform and ansible <br />
Steps to Run This Assignment. <br /> <br />
Download Your aws credential file and store it . <br /><br />

Step 1. Clone this Repo <br /> <br />
Step 2. Run below command in cloned folder to initialize it as a working directory. <br />
  &emsp;&emsp;    " $ terraform init " <br /><br />
Step 3. Do a Test Run Using Command.<br />
  &emsp;&emsp;    " $ terraform plan " <br /><br />
Step 4. To build the Infrastructure (Instance) Run the command <br />
  &emsp;&emsp;    " $ terraform apply " <br /><br />
Step 5. Then Check Your Aws EC2 instance console <br />
  &emsp;&emsp; ==> A new ec2 instance has been launched <br />
  &emsp;&emsp; ==> You can check using ssh using key_pair key and public ip <br />
  &emsp;&emsp; ==> " $ ssh -i key.pem user@ec2-public-ip " <br /> <br /> <br />
# DONE
======================================================================================<br />
&emsp;&emsp;&emsp;&emsp; NOW TO INSTALL WEB SERVER USING ANSIBLE <br />
======================================================================================<br /> <br />
Step 1. Configure Your inventory replacing your instance public ip Address <br /> <br />
Step 2. Run command " $ ansible-playbook -i <inventory_path> Deploy_Server.yml " <br /><br />
Step 3. Check Web Server Running by going on ip " http://ec2-public-ip:80 " <br /><br /><br /><br /><br />

==> NOTE. Replace ec2-public-ip with public ip taken from running instance.
