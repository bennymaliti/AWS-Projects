## High Availability Architecture for e-commerce Application
In this project, I develop an infrastructure for a high-availability architecture for an ecommerce application. The architecture address the limitations of an ecommerce system that is currently having limitations of the system such as frequent downtime, a lack of fault tolerance, inefficient resource utilisation and having a manual recovery process.

## 🚀 Overview
To achieve high-availability architecture, we will utilise a number of **AWS services and components**  
- **Amazon EC2 with Auto Scalling**      
      ➡️ Redundancy: Deploy instances across 3 AZ's to eliminate single points of failure.  
      ➡️ Scalability: Auto Scaling to adjust capacity based on CPU/memory usage. (eg. scale out at 70% CPU)  
      ➡️ Cost Efficiency: Replace manual scaling with dynamic provisioning
- **Application Load Balancer**    
      ➡️ Traffic Distribution : Routes HTTP/HTTPS traffic to healthy instances in multiple AZs.  
      ➡️ Integration with Auto Scaling : Automatically registers new instances.  
      ➡️ SSL Offloading: Reduces compute load on EC2 by handling TLS termination.  
- **Amazon RDS (Multi-AZ + Read Replicas)**    
      ➡️ High Availability: Multi-AZ deployment ensures automatic failover (standy replica in another AZ).  
      ➡️ Read Scalability: Read replicas handle product searches / catalog reads, reducing primary DB load.  
- **Amazon ElasticCache (Redis)**    
      ➡️ Caching: Stores session data and product listings (e.g., 1M + SKUs), reducing DB read latency by ~60%  
      ➡️ Managed Service: Automated patching and backups.  
- **Amazon CloudFront**    
      ➡️ Global latency Reduction: Caches static assets (images, CSS/JS) at locations closer to the customer.  
      ➡️ DDoS Protection: Integrated with AWS Shield Standard.  
- **VPC with Public/Private Subnets**    
      ➡️ Security: EC2 instances in private subnets; ALB in public subnets.  
      ➡️ NAT Gateway: Allows private instances to download updates securely.
- **CloudWatch & SNS**  
      ➡️ Automated Recovery: Triggers Auto Scaling on CPU/health-check failures.  
      ➡️ Alerts: SNS notifications to DevOps team via email/SMS for critical issues (e.g., RDS failover).  

## 🪛 Implentations Steps  
1. **VPC Setup**  
      * Create a VPC with public/private subnets across 3 AZs.
      * Configure route tables and NAT gateway for private subnets.
2. **EC2 & Auto Scaling**
      * Launch a Linux AMI with the e-commerce app (e.g., Node.js + Nginx)
      * Define Auto Scaling policies (e.g., minimum : 3, maximum : 6 instances, scale-out at 60% CPU).  
3. **ALB Configuration**
      * Setup HTTPS listener with ACM certificate.
      * Configure health checks (e.g., /health endpoint)  
4. **RDS Deployment**  
      * Create a **Multi-AZ** Postgre SQL instance.
      * Add 2 read replicas for read-heavy queries
5. **ElastiCache Cluster**  
      * Deploy Redis cluster in the same VPC.
      * Update app to cache product data (TTL: 1 hour.)  
6.  **CloudFront Distribution**
      * Origin: S3 bucket for static assets.
      * Configure caching policies (TTL: 7 days).   
7. **Monitoring & Alerts**  
      * Create **CloudWatch alarms** for Database, CPU, EC2 health and Cache misses.
      * Set up **SNS** topic for alerts

## 🛠️ **Testing & Validation**  
1. **Load Testing:**  
      * Use AWS Load Testing (Apache JMeter) to simulate 10K concurrent users.  
      * Validate Auto Scaling adds instances within 5 minutes.  
2. **Failure Simulation:**  
      * Terminate an EC2 instance; verify ALB redirects traffic.  
      * Reboot primary RDS; confirm Multi-AZ failover (<2 mins downtime).  

## 💰**Cost Optimisation**  
1. **Reserved Instances:** Apply to RDS and EC2 for steady-state workloads.
2. **Lifecycle Policies:** Archive old CloudFront logs to S3 Glacier.

## ⚠️**Security**
1. **IAM Roles:** Least privilege access for EC2 (e.g., only S3 read access).
2. **Encryption:** TLS 1.2 for ALB, AES-256 for RSS/ElastiCache at rest.
3. **WAF:** Block SQLi/XSS attachs via CloudFront.

## ✔️ **Outcome**
By implementing an application loadbalancer, the application is able to achieve 99.99% uptime during sale traffic events (50K RPM).
The Database load is equally able to be reduced by 40% via caching.

## 📌 **Conclusion**
This project guide gives an understanding of an application that is able to achieve fault tolerance and redudancy, by distributing resources across multiple Availability Zones ensuring that the application remains accessible.

The scalability is the most crucial aspect of the architecture to handle high traffic loads and adjust the number of instances based on demand.

For a full comprehensive step-by-step guide, please visit the full post: [High Availability E-commerce Application Architecture on AWS](https://medium.com/@bennymaliti/high-availability-e-commerce-application-architecture-on-aws-5eebac06975b)
