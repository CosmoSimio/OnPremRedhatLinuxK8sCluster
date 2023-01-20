provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "k8s_cluster_key" {
  key_name   = "k8s_cluster_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "k8s_cluster_sg" {
  name        = "k8s_cluster_sg"
  description = "Security group for Kubernetes cluster"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k8s_master" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.k8s_cluster_key.key_name
  security_groups = [aws_security_group.k8s_cluster_sg.name]
  user_data     = file("k8s_master_userdata.sh")
}

resource "aws_instance" "k8s_node" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.k8s_cluster_key.key_name
  security_groups = [aws_security_group.k8s_cluster_sg.name]
  user_data     = file("k8s_node_userdata.sh")
}
