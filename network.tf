resource "aws_vpc" "tf_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    
    tags = {
        Name = "tf_vpc"
        BuildWith = "terraform"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = "${aws_vpc.tf_vpc.id}"
    cidr_block = "10.0.1.0/24"
    
    tags = {
        Name = "Public Subnet"
        BuildWith = "terraform"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = "${aws_vpc.tf_vpc.id}"
    cidr_block = "10.0.2.0/24"

    tags = {
        Name = "Private Subnet"
        BuildWith = "terraform"
    }
}

resource "aws_internet_gateway" "internet_gateway" { 
    vpc_id = "${aws_vpc.tf_vpc.id}"

    tags = {
        Name = "Internet Gateway"
        BuildWith = "terraform"
    }
}

# create external route to IGW
resource "aws_route" "external_route" {
    route_table_id = "${aws_vpc.tf_vpc.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id }"
}

# adding an elastic IP
resource "aws_eip" "elastic_ip" {
    vpc = true
    depends_on = [aws_internet_gateway.internet_gateway]

}

# Creating NAT Gateway
resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.elastic_ip.id}"
    subnet_id = "${aws_subnet.public_subnet.id}"
    depends_on = [aws_internet_gateway.internet_gateway]
}

# creating private route table 
resource "aws_route_table" "private_route_table" {
    vpc_id = "${aws_vpc.tf_vpc.id}"

    tags = {
        Name = "Private Subnet Route Table"
        BuildWith = "terraform"
        }
    
}

# adding private route table to NAT
resource "aws_route" "private_route" {
    route_table_id = "${aws_route_table.private_route_table.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
}

# associate subnet public to public route table
resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = "${aws_subnet.public_subnet.id}"
    route_table_id = "${aws_vpc.tf_vpc.main_route_table_id}"
}

# associate subnet private subnet to private route table
resource "aws_route_table_association" "private_subnet_association" {
    subnet_id = "${aws_subnet.private_subnet.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}