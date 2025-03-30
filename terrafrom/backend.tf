terraform {
  backend "s3" {
    bucket = "devops-dashboard-terraform-state-1991"
    key    = "devops-dashboard/terraform.tfstate"
    region = "us-west-2"  # Your region
    encrypt = true
  }
}
