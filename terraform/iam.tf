/**
IAM Role for EKS Cluster (eks_service_role): Allows EKS to manage resources such as EC2 instances and VPCs.
IAM Role for EKS Worker Nodes (eks_node_role): Allows EC2 instances (worker nodes) to join the cluster and interact with AWS services like EC2 and CloudWatch.
Policy Attachments: Attaches AWS policies for cluster management (AmazonEKSClusterPolicy), worker nodes (AmazonEKSWorkerNodePolicy), and CloudWatch logging (CloudWatchAgentServerPolicy).
 */
# IAM Role for EKS control plane
resource "aws_iam_role" "eks_service_role" {
  name = "eks-service-role" # Role name for EKS service

  # Trust policy for the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com" # EKS service can assume this role
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })

  tags = {
    Name = "eks-service-role"
  }
}

# Attach EKS Cluster policy to the service role
resource "aws_iam_role_policy_attachment" "eks_service_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" # Allows EKS to manage resources
  role       = aws_iam_role.eks_service_role.name               # Role to attach the policy to
}

# IAM Role for EKS worker nodes
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role" # Role name for EKS nodes

  # Trust policy for the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com" # EC2 instances can assume this role
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })

  tags = {
    Name = "eks-node-role"
  }
}

# Attach EKS worker node policy to the node role
resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" # Allows worker nodes to join the cluster
  role       = aws_iam_role.eks_node_role.name                     # Role to attach the policy to
}

# Attach CloudWatch logging policy to the node role
resource "aws_iam_role_policy_attachment" "eks_node_logging_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy" # Allows nodes to push logs to CloudWatch
  role       = aws_iam_role.eks_node_role.name                       # Role to attach the policy to
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}