output "eks-vpc-public-subnet-1a_id" {
  value = [aws_subnet.eks-vpc-public-subnet-1a.id]
}

output "eks-vpc-public-subnet-1b_id" {
  value = [aws_subnet.eks-vpc-public-subnet-1b.id]
}

output "eks-vpc-private-subnet-1a_id" {
  value = [aws_subnet.eks-vpc-private-subnet-1a.id]
}

output "eks-vpc-private-subnet-1b_id" {
  value = [aws_subnet.eks-vpc-private-subnet-1b.id]
}
