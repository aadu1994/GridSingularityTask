provider "aws" {
         region= "me-south-1"
}


# # 1. Create vpc

 resource "aws_vpc" "prod-vpc" {
   cidr_block = "10.0.0.0/16"
   tags = {
     Name = "production"
   }
 }

# # 2. Create Internet Gateway

 resource "aws_internet_gateway" "gw" {
   vpc_id = aws_vpc.prod-vpc.id


 }
# # 3. Create Custom Route Table

 resource "aws_route_table" "prod-route-table" {
   vpc_id = aws_vpc.prod-vpc.id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.gw.id
   }

   route {
     ipv6_cidr_block = "::/0"
     gateway_id      = aws_internet_gateway.gw.id
   }

   tags = {
     Name = "Prod"
   }
 }

# # 4. Create a Subnet 

 resource "aws_subnet" "subnet-1" {
   vpc_id            = aws_vpc.prod-vpc.id
   cidr_block        = "10.0.2.0/24"
   availability_zone = "me-south-1a"

   tags = {
     Name = "prod-subnet"
   }
 }

# # 5. Associate subnet with Route Table
 resource "aws_route_table_association" "a" {
   subnet_id      = aws_subnet.subnet-1.id
   route_table_id = aws_route_table.prod-route-table.id
 }

resource "aws_security_group" "web-node" {
  name = "web-node"
  description = "Web Security Group"
  vpc_id      = aws_vpc.prod-vpc.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }    
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# # 7. Create a network interface with an ip in the subnet that was created in step 4

 resource "aws_network_interface" "web-server-nic" {
   subnet_id       = aws_subnet.subnet-1.id
   private_ips     = ["10.0.2.50"]
   security_groups = [aws_security_group.web-node.id]

 }

# # 8. Assign an elastic IP to the network interface created in step 7

 resource "aws_eip" "two" {
   vpc                       = true
   network_interface         = aws_network_interface.web-server-nic.id
   associate_with_private_ip = "10.0.2.50"
   depends_on                = [aws_internet_gateway.gw]
 }

 output "server_public_ip" {
   value = aws_eip.two.public_ip
}

resource "aws_instance" "GridSingularity" {
        ami = "ami-00a33a0976ef4d65f"
        instance_type = "t3.micro"
        key_name = "terraform-test"
       # security_groups = ["${aws_security_group.web-node.name}"]
        #associate_public_ip_address = true
    
network_interface {
     device_index         = 0
     network_interface_id = aws_network_interface.web-server-nic.id
   }

#    user_data = <<-EOF
 #              #!/bin/bash
#		sudo apt update -y
 #               sudo apt install apache2 -y
  #              sudo systemctl start apache2
   #             EOF        
    	user_data = "${file("install.sh")}"
      #  user_data = "${file("docker.sh")}"
      
      tags = {
                 Name = "GridSingularity"
                            }
}
output "instance_ip_addr" {
  value = aws_instance.GridSingularity.public_ip
}
