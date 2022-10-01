### your docs here

1. Make sure you have AWS CLI Installed, if not run:

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

```

2. Configure AWS Profile that will be used by Terraform localy **(NAME IT AS default!)**. Please make sure it has AdministratorAccess permissions.
```
aws configure --profile default
```

3. Application will require gihub **OAuth** token for a Pipeline. Please generate one and save it somewhere safe for now we will use it in the later steps.

    Instruction:

```
https://catalyst.zoho.com/help/tutorials/githubbot/generate-access-token.html
```

4. Go to **/terraform/env/dev/terragrunt.hcl** and configure your application in configuration block:

5. Return back to project folder and run initial infrastructure deployment with.
```
./make.sh <github_Oauth_key_from_step_3>
```

6. All further changes may be implied with
```
terragrunt apply    # For a specific module
```
   or
```
terragrunt run-all apply    # For the whole infrastructure
````

7. After provisioning run the following command to configure cluster access localy.

```
aws eks --region <region> update-kubeconfig --name <cluster-name>
```

### On Delete: Remove all contents of ECR repo's and S3 bucket contents used by CodePipeline
