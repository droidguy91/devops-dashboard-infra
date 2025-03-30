/**
EKS Cluster: Creates an EKS control plane (my-eks-cluster).
The VPC configuration specifies the subnets where the EKS cluster will be deployed.
 */

# Create EKS Cluster
resource "aws_eks_cluster" "example" {
  name     = "my-eks-cluster"  # Name of the EKS cluster
  role_arn = aws_iam_role.eks_service_role.arn  # IAM role for EKS control plane

  # VPC configuration for the EKS cluster
  vpc_config {
    subnet_ids = [aws_subnet.subnet_public.id, aws_subnet.subnet_private.id]  # Subnets for the EKS cluster
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_service_role_policy  # Ensure IAM role is created first
  ]
}
