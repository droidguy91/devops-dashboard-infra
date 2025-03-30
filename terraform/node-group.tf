/*
EKS Node Group: Specifies the worker nodes for the EKS cluster, with scaling options (desired, minimum, and maximum).\
The nodes are launched in the private subnet and associated with the EKS node IAM role
 */

# EKS Node Group (worker nodes)
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name  # EKS cluster name
  node_group_name = "example-node-group"  # Name of the node group
  node_role_arn   = aws_iam_role.eks_node_role.arn  # IAM role for worker nodes
  subnet_ids      = [aws_subnet.subnet_private.id]  # Private subnet for worker nodes
  scaling_config {
    desired_size = 2  # Initial number of worker nodes
    max_size     = 3  # Maximum number of worker nodes
    min_size     = 1  # Minimum number of worker nodes
  }
}
