resource "aws_vpc" "main" {             
    cidr_block=var.vpc_cidr             
}

resource "aws_subnet" "pubblica" {      
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_pubb        
    availability_zone = "eu-west-1a"    
    tags = {
        Name="snake_subnet_pubblica"
    }
}

resource "aws_subnet" "pubblica2" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_pubb2
    availability_zone = "eu-west-1b"
    tags = {
        Name="snake_subnet_pubblica2"
    }
}

resource "aws_subnet" "privata" {
    vpc_id=aws_vpc.main.id
    cidr_block = var.subnet_priv
    availability_zone = "eu-west-1a"
        tags = {
        Name="snake_subnet_privata"
    }
}

resource "aws_subnet" "privata2" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.subnet_priv2
    availability_zone = "eu-west-1b"
    tags = { Name = "snake_subnet_privata2" }
}

resource "aws_internet_gateway" "main" {        
    vpc_id = aws_vpc.main.id                   
    tags = {        
        Name= "snake_igw"
    }
}

resource "aws_route_table" "privata" {         
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "privata" {  
    subnet_id = aws_subnet.privata.id               
    route_table_id = aws_route_table.privata.id     
}

resource "aws_route_table_association" "privata2" {
    subnet_id      = aws_subnet.privata2.id
    route_table_id = aws_route_table.privata.id 
}

resource "aws_route_table" "pubblica" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "pubblica" {
    subnet_id = aws_subnet.pubblica.id
    route_table_id = aws_route_table.pubblica.id
}

resource "aws_route_table_association" "pubblica2" {
    subnet_id      = aws_subnet.pubblica2.id
    route_table_id = aws_route_table.pubblica.id
}

resource "aws_route" "internet_access" {            
    route_table_id = aws_route_table.pubblica.id    
    destination_cidr_block = "0.0.0.0/0"            #destinazione internet
    gateway_id = aws_internet_gateway.main.id       #tramite igw
}

resource "aws_eip" "nat" {                          #creiamo un eip per nat gateway
    domain = "vpc" 
}

resource "aws_nat_gateway" "main" {                 
  allocation_id = aws_eip.nat.id                   
  subnet_id = aws_subnet.pubblica.id                
}

resource "aws_route" "private_nat_access" {         #diamo accesso ad internet alla subnet privata
    route_table_id = aws_route_table.privata.id     
    destination_cidr_block = "0.0.0.0/0"            #destinazione internet
    nat_gateway_id =    aws_nat_gateway.main.id         #tramite nat gateway
}