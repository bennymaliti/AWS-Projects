## High Availability Architecture for e-commerce Application
In this project, I develop an infrastructure for a high-availability architecture for an ecommerce application. The architecture address the limitations of an ecommerce system that is currently having limitations of the system such as frequent downtime, a lack of fault tolerance, inefficient resource utilisation and having a manual recovery process.

## 🚀 Overview
To achieve high-availability architecture, we will utilise a number of **AWS services and components**  
- **Amazon EC2 with Auto Scalling**      
      ➡️ Redundancy       => Deploy instances across 3 AZ's to eliminate single points of failure.  
      ➡️ Scalability      => Auto Scaling to adjust capacity based on CPU/memory usage. (eg. scale out at 70% CPU)  
      ➡️ Cost Efficiency  => Replace manual scaling with dynamic provisioning
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
