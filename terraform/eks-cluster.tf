
module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "20.24.2"
  cluster_name                             = "devops-dashboard-eks"
  cluster_version                          = "1.32"
  vpc_id                                   = local.vpc_id
  subnet_ids                               = local.subnets
  cluster_endpoint_public_access           = true
  bootstrap_self_managed_addons            = true
  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API_AND_CONFIG_MAP"

  eks_managed_node_group_defaults = {
    # node_groups is hardcoded to read instance_type from here unless you
    # have a custom Launch Template
    instance_types   = ["t3.medium"]
    root_volume_type = "gp3"
  }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    devops-dashboard = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      max_size       = 3
      min_size       = 1

      subnets                = local.subnets[0]
      disk_size              = 100
      create_launch_template = true
      name                   = "devops-dashboard"

      metadata_http_tokens                 = "required"
      metadata_http_put_response_hop_limit = 2

      disk_encrypted = true

      iam_role_additional_policies = {
        additional = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

}
