module "vpc" {
  source = "./modules/vpc"

}


resource "aws_iam_role" "EKSClusterRole" {
  name = "EKSClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.EKSClusterRole.name
}

resource "aws_iam_role" "NodeGroupRole" {
  name = "EKSNodeGroupRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.NodeGroupRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.NodeGroupRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.NodeGroupRole.name
}


resource "aws_eks_cluster" "demo" {
  name     = "demo"
  role_arn = aws_iam_role.EKSClusterRole.arn
  version  = "1.21"

  vpc_config {
    subnet_ids = flatten([module.vpc.eks-vpc-public-subnet-1a_id, module.vpc.eks-vpc-public-subnet-1b_id, module.vpc.eks-vpc-private-subnet-1a_id, module.vpc.eks-vpc-private-subnet-1b_id])
  }

  depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy]
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.NodeGroupRole.arn

  subnet_ids = flatten([module.vpc.eks-vpc-private-subnet-1a_id, module.vpc.eks-vpc-private-subnet-1b_id])

  capacity_type  = "SPOT"
  instance_types = ["t3a.medium"]
  ami_type       = "AL2_x86_64"
  disk_size      = 15

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }


  labels = {
    role = "general"
  }

  remote_access {
    ec2_ssh_key = "rahul"

  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy

  ]
}


data "tls_certificate" "eks" {
  url = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}


resource "null_resource" "merge_kubeconfig" {
  triggers = {
    always = timestamp()
  }

  depends_on = [aws_eks_cluster.demo]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      set -e
      echo 'Applying Auth ConfigMap with kubectl...'
      aws eks wait cluster-active --name 'demo'
      aws eks --region=${var.region} update-kubeconfig --name demo --profile=${var.profile}
    EOT
  }
}

resource "aws_security_group" "jenkins_server_sg" {
  name        = "jenkins_server_sg"
  description = "Security group for jenkins server"
  vpc_id      = element(module.vpc.vpc_id, 0)

  ingress {
    description = "Allow all traffic through port 8080"
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #   # Since we only want to be able to SSH into the Jenkins EC2 instance, we are only
  #   # allowing traffic from our IP on port 22
  ingress {
    description = "Allow SSH from my computer"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "jenkins-instance" {
  ami                    = var.ami
  subnet_id              = element(module.vpc.eks-vpc-public-subnet-1a_id, 0)
  instance_type          = var.instance-type
  key_name               = var.key-name
  user_data              = file("./install_jenkins.sh")
  vpc_security_group_ids = ["${aws_security_group.jenkins_server_sg.id}"]

  tags = {
    Name = "jenkins_server"
  }
}

