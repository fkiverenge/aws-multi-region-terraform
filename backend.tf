terraform {
  backend "s3" {
    bucket       = "example-bucket-name"
    key          = "terraform-aws-lab/network.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
