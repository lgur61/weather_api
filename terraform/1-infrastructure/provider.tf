provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "lg-terraform-state-bucket"
    key    = "Production/infrastructure.tfstate"
    region = "us-east-1"

  }
}
