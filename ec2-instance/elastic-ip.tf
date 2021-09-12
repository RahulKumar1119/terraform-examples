resource "aws_eip" "my-ip" {
    instance = aws_instance.my-ec2-vm.id
    vpc = true
    depends_on = [
      aws_internet_gateway.vpc-dev-igw
    ]
}