# Static Website Hosting on AWS S3
This guide explains how to host a static website on AWS S3 and automate deployments using GitHub Actions. This is a summary of the steps outlined in the [full article](https://benmaliti.medium.com/static-website-hosting-on-aws-s3-077f966dbb33) authored by [Benny Maliti](https://www.linkedin.com/in/bennymaliti/)

## Overview
By the end of this guide, you will
- Create and configure an S3 bucket for static website hosting.
- Setup bucket policies for public access.
- Upload your static assets to S3.
- Automate your deployments with GitHub Actions

## Prerequisites
- ** AWS Account: An active AWS account with permissions to create S3 buckets and manage IAM.
- ** AWS CLI: Installed and configured locally. Run <ins> aws configure </ins> to set up your credentials and default region.
** Git & GitHub: A GitHub repository containing your static site files (HTML, CSS, JS, assets)

