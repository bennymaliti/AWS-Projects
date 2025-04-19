# Static Website Hosting on AWS S3
This guide explains how to host a static website on AWS S3 and automate deployments using GitHub Actions. This is a summary of the steps outlined in the [full article](https://benmaliti.medium.com/static-website-hosting-on-aws-s3-077f966dbb33) authored by [Benny Maliti](https://www.linkedin.com/in/bennymaliti/)

## 🚀Overview
By the end of this guide, you will
- Create and configure an S3 bucket for static website hosting.
- Setup bucket policies for public access.
- Upload your static assets to S3.
- Automate your deployments with GitHub Actions

## 🛠️Prerequisites
- **AWS Account:** An active AWS account with permissions to create S3 buckets and manage IAM.
- **AWS CLI:** Installed and configured locally. Run <ins> aws configure </ins> to set up your credentials and default region.
- **Git & GitHub:** A GitHub repository containing your static site files (HTML, CSS, JS, assets)

## Configure AWS CLI
- Install or update the [AWS CLI](https://awscli.amazonaws.com/AWSCLIV2.msi)
- **Verify the installation:** - open Start menu, search for cmd to open command prompt and type "C:\> aws --version"
- Open command prompt and type aws configure
- Enter your User AWS Access Key ID
- Enter your User AWS Secret Access Key
- Press Enter to confirm Default region
- Press Enter to confirm Default output format

## 1. Create an S3 Bucket
# Replace your-bucket-name and region with your values
aws s3 mb s3://your-bucket-name --region region

## 2. Enable Static Website Hosting
aws s3 website s3://your-bucket-name --index-document index.html --error-document error.html

## Tip: **Note the endpoint URL returned, e,g.** http://your-bucket-name.s3-website-region.amazonaws.com

## 3. Configure Public Access
**1. Block Public Access:** Disable block settings for this bucket in the AWS S3 console under **Permissions 
