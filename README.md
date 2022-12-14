
# terraform-aws-nodejs-fargate 

Deploy simple nodejs application to AWS ECS with Terraform


## Deployment

To deploy nodejs application, you need to manually apply 2 module in **terraform** folder

### Configure AWS CLI

[Visit this link for configuration](https://linuxhint.com/configure-aws-cli-credentials/)

### Apply first module (1-infrastructure)
- Change **production.tfvars** and **provider.tf** for your needs
```bash
  cd terraform/1-infrastructure
  terraform init
  terraform plan -var-file="production.tfvars"
  terraform apply -var-file="production.tfvars"
```

### Apply second module (2-platform)
- Change **production.tfvars** and **provider.tf** for your needs
```bash
  cd terraform/2-platform
  terraform init
  terraform plan -var-file="production.tfvars"
  terraform apply -var-file="production.tfvars"
```

### Apply third module (3-application)
- Change **production.tfvars** and **provider.tf** for your needs
- Add environment variables to Github Repository Action secrets
  ```bash
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  ```
- This module will be applied by **Github Actions Workflow** (deploy.yml) when you push your commit with change under **./nodeapp** folder.