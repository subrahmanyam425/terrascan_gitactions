# Create IAM User
resource "aws_iam_user" "iam_user" {
  name = var.aws_iam_user

}

# Create Access Key and Secret Key for IAM User
resource "aws_iam_access_key" "iam_user_key_pairs" {
  user = aws_iam_user.iam_user.name
}

# Store Access Key and Secret Key in AWS SSM
resource "aws_ssm_parameter" "iam_user_aws_access_key" {
  name        = "iam-user-accesskey"
  description = "Access key for IAM User"
  type        = "SecureString"
  value       = aws_iam_access_key.iam_user_key_pairs.id

}

resource "aws_ssm_parameter" "iam_user_aws_secret_key" {
  name        = "iam-user-secretkey"
  description = "Secret Key for IAM User"
  type        = "SecureString"
  value       = aws_iam_access_key.iam_user_key_pairs.secret
}

###ec2 related creation
terraform {
  backend "s3" {
    bucket         = "subbu-s3-demo-xyz" # change this
    key            = "subbu/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}
resource "aws_instance" "ec2" {
  instance_type = "t2.micro"
  ami = "ami-03f4878755434977f" 
  subnet_id = aws_subnet.my_subnet.id
  tags = {
    Name = "Session_2_Demo"
  }
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "Session2_vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  #availability_zone = "us-west-2a"

  tags = {
    Name = "Session2_subnet"
  }
}
