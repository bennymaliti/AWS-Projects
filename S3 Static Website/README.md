## Static Website Hosting on AWS S3
This project works through how to host a static website on AWS S3. This is a summary of the steps outlined in the [full article](https://benmaliti.medium.com/static-website-hosting-on-aws-s3-077f966dbb33) authored by [Benny Maliti](https://www.linkedin.com/in/bennymaliti/)

## 🚀Overview
By the end of this project, you will
- Create and configure an S3 bucket for static website hosting.
- Setup bucket policies for public access.
- Upload your static assets to S3.  

## 🛠️Step 1: Prepare Your Website Content
- **Create Your Content:**
    Prepare your static website content (HTML, CSS, JavaScript, Images, etc.)
    Make sure you have an entry point file, usually `index.html` and optionally an error page `error.html`
  
## Step 2: Create an S3 Bucket and Enable Static Website Hosting  
1. **Sign in to AWS:**  
- Log in to the [AWS Management Console](https://aws.amazon.com/console)  

2. **Navigate to Amazon S3:**  
- In the AWS Console, search for and select **S3.**  

3. **Create a New Bucket:**  
- Click the **Create Bucket** button
- **Bucket Name:** Enter a unique name that will ideally match your custom domain name (e.g., `my-unique-static-website`).
- **Region:** Select a region that's geographically close to your primary audience.
- Leave the rest of the default settings for now.
- Click **Create Bucket**.

## Step 3: Configure Bucket Permissions for Public Access
Since website files need to be publicly accessible, you must configure the bucket to allow public read access.  
1. **Disable Block Public Access:**  
- In the S3 bucket settings, navigate to the **Permissions** tab.
- Under **Block Public Access (bucket settings),** click **Edit** and uncheck the options that block public access if you plan to serve a public website.  
(Be mindful: AWS recommends keeping public access blocked if you're serving private or sensitive content. For static website, you intentionally allow read access for all users.)  

2. **Add a Bucket Policy:**  
- Still under **Permissions** tab, scroll to **Bucket Policy** and click **Edit**.
- Add a policy similar to bennymaliti-s3.json (replace your-bucket-name with your actual bucket name).
- Click **Save** to apply policy.

## Step 4: Upload Your Website Files  
1. **Open Your Bucket:**  
- Select the newly created bucket (your-bucket-name) from the S3 dashboard.  
2. **Upload Files:**  
- Click **Upload** button.
- Choose the files/folders of your website (including `index.html`, `error.html`, CSS, JavaScript, images, etc).
- Follow the prompts and click through; accept the defaults.
- Complete the upload process.  

## Step 5: Request an SSL Certificate with AWS Certificate Manager (ACM).  
1. **Open ACM:**  
- In the AWS Management Console, search for and open **Certificate Manager.**  
2. **Request a Public Certificate:**  
- Click **Request a certificate** and choose **Request a public certificate**.
- **Add Domain Name:**  
    Enter your custom domain (e.g, `example.com`) and, if desired, add any subdomains (e.g., `www.example.com`).  
3. **Validation Method:**  
- Choose **DNS validation** (this is the easiest if you are using Route 53 for DNS Management).
4. **Review and Request:**
  Review the settings and click **Confirm and request.**  
5. **DNS Validation:**  
- ACM will provide one or more CNAME records that you need to add to your DNS.
- You can add these records manually in Route 53 later or, if your domain is registered in Route 53, use the automatic validation option.
- **Wait for Validation:**  
    Once the CNAME records are in place, ACM will validate your domain and issue the certificate. This process may take a few minutes.  

## Step 6: Create a CloudFront Distribution  
Since S3 website endpoints don't support HTTPS, we use CloudFront to front the content.  
1. **Open CloudFront:**  
In the [AWS Management Console](https://aws.amazon.com/console/), search for and navigate to **CloudFront**.

2. **Create a New Distribution:**
- Click **Create Distribution** and choose **Web** (the standard distribution).  

3. **Origin Settings:**  
- For **Origin Domain Name,** select S3 bucket's website endpoint (it should appear in the list; it will look like `example.com.s3-website-<region>.amazonaws.com`).
- Set **Origin Protocol Policy** to **HTTP Only** (since S3 website endpoints serve over HTTP).  

4. **Default Cache Behaviour:**  
- Accept the default settings or customise as desired.  

5. **Distribution Settings:**  
- **Alternate Domain Names (CNAMEs):**
    Enter your custom domain name(s) (e.g., `example.com`, `www.example.com`).
- **SSL Certificate:**  
    Under **Custom SSL Certificate,** select the ACM certificate you just validated.
- **Default Root Object:**  
    Set this to `index.html` (or your chosen entry point).
6. **Create Distribution:**
  Click **Create Distribution** and allow some time (typically 15 - 20 minutes) for CloudFront to deploy your distribution.

## Step 7: Configure Route 53 to Use Your Custom Domain
1. **Open Route 53:**  
In the AWS Management Console, navigate to **Route 53.**
2. **Create or Use an Existing Hosted Zone:**
   - If you haven't already set up a hosted zone for your domain, click **Create Hosted Zone** and follow the prompts.
3. **Add an Alias Record for Your Domain:**  
    - Within your hosted zone, click **Create Record.**
    - **Record Name:**  
        Leave it blank for the root domain (`example.com`) or specify `www` if you are setting up a subdomain.
    - **Record Type:**
        Choose **A - IPv4 address.**
    - **Alias:**
      Enable the Alias option.
    - **Alias Target:**
      From the dropdown list, choose your CloudFront distribution (the domain name assigned automatically by the CloudFront,         e.g., `dxxxxxxxxxxxxx.cloudfront.net`).
    - **Create Record.**
4. **(Optional) Add a Record for www:***  
    - If you want both `example.com` and `www.example.com` to point to your CloudFront distribution, repeat the alias record for the `www` subdomain.  
5. **Validate Domain Records:**  
    - Give DNS time to propagate (this can take a few minutes up to an hour).
    - Once propoagation is complete, navigate to your custom domain using HTTPS.

## Step 8: Test Your Setup  
- **Access Your Website:**
    Open your web browser and navigate to your custom domain (e.g., `https://example.com`).
- **Verify HTTPS:**
    Make sure the SSL certificate is recognised and your website loads securely via Cloudfront.

## Additional Considerations  
- **ACM Certificate Renewal:**
    ACM automatically renews certificates as long as DNS validation remains in place.
- **CloudFront Caching:**
    If you update website content, you may need to invalidate CloudFront caches so that users see the new content promptly.
- **Monitoring & Logging:**  
    Consider enabling logging in CloudFront and S3 for audit and performance tracking purposes.
  
## Sample Website Page
This section includes some example website files for reference :
- index.html : A basic static web page with  "**Welcome!** This is my homepage hosted on AWS S3" sample page.
- error.html : A custom error page (404) for handling missing files.
- Image file : [Healthy Food](https://maliti-aws-project/s3.eu-west-2.amazonaws.com/healthy+food.jpg) - An image of colourly healthy food on a plate.

## 🌐Personal Website  
The personal website for this project is hosted at [Benny Maliti](https://bennymaliti.co.uk)  

## Conclusion  
This project walked us through setting up a static S3 website, securing it with ACM via CloudFront, and configuring Route 53 to handle the custom domain.  


