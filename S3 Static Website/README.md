## Static Website Hosting on AWS S3
This project works through how to host a static website on AWS S3. This is a summary of the steps outlined in the [full article](https://benmaliti.medium.com/static-website-hosting-on-aws-s3-077f966dbb33) authored by [Benny Maliti](https://www.linkedin.com/in/bennymaliti/)

## 🚀Overview
By the end of this guide, you will
- Create and configure an S3 bucket for static website hosting.
- Setup bucket policies for public access.
- Upload your static assets to S3.  

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
1. **Using AWS Console:** Navigate to S3 and select the policy then under **Permissions ➡️ Bucket Policy and paste the JSON code, then click Save changes.
2. **Using GitHub** Create a bucket file named policy.json in your project's root directory (the top-level folder of your cloned Git repository, where .git and README.md reside) and paste the following JSON into policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
       "Sid": "PublicReadGetObject",
       "Effect": "Allow",
       "Principal": "*",
       "Action": "s3.GetObject",
       "Resource": "arn:aws:s3:::your-bucket-name/*"
     }
   ]
}
3. Apply it using AWS CLI (locally configured): Ensure aws configure with AWS credentials has been applied.
aws s3api put-bucket-policy --bucket your-bucket-name --policy file://policy.json
4. Either method will apply the policy and make your buckets objects publicly readable
5. Sync your local build from GitHub to the bucket: aws s3 sync ./public s3://your-bucket-name --all public-read
6. The site is now live at: http://your-bucket-name.s3-website-region.amazonaws.com

## Sample Website Page
This guide includes some example website files for reference :
- index.html : A basic static web page with  "**Welcome!** This is my homepage hosted on AWS S3" sample page.
- error.html : A custom error page (404) for handling missing files.
- Image file : [Healthy Food](https://maliti-aws-project/s3.eu-west-2.amazonaws.com/healthy+food.jpg) - An image of colourly healthy food on a plate.

## 🌐Custom Domain with Route 53 - Optional
1. In AWS Management Console, go to **Route 53**
2. Click Get started
3. Select **Create hosted zones**
4. Click **Get started**
5. Enter a domain name
6. On the type, choose Public Hosted Zone
7. Click **Create hosted zone**
8. Add an alias A record pointing to the S3 website endpoint


