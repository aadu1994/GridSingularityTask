# GridSingularityTask

These are the steps to run this automation. The terraform file created for this task is main.tf. It creates a new instance on AWS. It also creates a security group which includes
opening of port 22 and port 80 over the internet for the new instance.

1) Clone the git repository to you machine using " git clone https://github.com/aadu1994/TerraformDeploymentAWS"
2) You would need to install aws tools for this and need to run "aws configure" to enter your keys
3) then you would run the command terraform init
4) Then you will run the command 'terraform plan' to see what the out will be. Then run 'terraform apply'. Once this is completed it will give the output showing the public IP of the new VM
5) This will create a new ubuntu based aws instance. It will use the file named  "install.sh" to install docker and jenkins on the new instance. This file also includes commands for 
writing a DockerFile which will create and image for nginx. After this the file runs the command to open the container. You will be able to acces nginx  via the following link on your browser

"http://public-ip"    (Use the IP given in the output when the "terraform apply" command completes.
