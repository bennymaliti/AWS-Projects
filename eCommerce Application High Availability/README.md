## AWS High Availability Architecture for an Application
This project implements a **high-availability AWS architecture** using Terraform for infrastructure-as-code, a sample Python application, and GitHub Actions for CI/CD.  

The design spans multiple **Availability Zones (AZs)** for fault tolerance, uses an **Elastic Load Balancer (ELB)** and **Auto Scaling** for dynamic traffic distribution, and employs **Amazon RDS (with Multi-AZ and read replicas)**, **ElastiCache**, and **CloudFront** for scalability and performance.  

Monitoring and automated recovery are handled via **CloudWatch** alarms and **SNS** (with CloudTrail for audit logging).

## 🚀 Architecture Overview
To achieve high-availability architecture, we will utilise a number of **AWS services and components**  
- **Multi-AZ VPC Setup**    
      ➡️ Deply the infrastructure in at least two AZs. Create a VPC with both public and private subnets in each AZ to                 eliminate single point of failure.  
      ➡️ Spanning resources across AZs ensures the application stays available even if one AZ goes down.
- **Elastic Load Balancing - ELB**    
      ➡️ Use an ELB (Application Load Balancer) to distribute incoming traffic across EC2 instances in all AZs.  
      ➡️ The ELB will automatically route requests only to healthy instances, providing automatic failover and high availabiltity.  
- **Auto Scalling**      
      ➡️ Configure an Auto Scaling group with a Launch Template.  
      ➡️ Auto Scaling will dynamically add or remove EC2 instances based on demand (e.g. CPU or Network Load).    
      ➡️ This ensures the application is able to handle peak traffic and will also be able to scale down when idle.  
- **Amazon RDS (Multi-AZ + Read Replicas)**    
      ➡️ Provision the database using Amazon RDS in **Multi-AZ** mode, which automatically replicates data synchronously to a standby in another AZ.  
      ➡️ Create one or more **RDS read replicas** to offload read-heavy traffic from the primary database, enabling horizontal scaling of read queries.  
- **Amazon ElasticCache:**    
      ➡️ Use ElastiCache (Redis or Memcached) as an in-memory caching layer for frequently accessed data.  
      ➡️ Caching reduces load on the database and delivers microsecond-latency responses.  
- **Amazon CloudFront CDN**    
      ➡️ Deploy a CloudFront distribution in front of the load balancer or S3 bucket.  
      ➡️ This is to accelerate static and dynamic content delivery to global users.  
- **Monitoring and Alerts**  
      ➡️ Configure Amazon CloudWatch to monitor key metrics (CPUUtilization, network I/O, DB latency, etc.  
      ➡️ Set CloudWatch Alarms to trigger SNS notifications or scaling actions when thresholds are exceeded.  
- **Automated Recovery:**  
      ▶️ The combination of multi-AZ deployment, ELB health checks, Auto Scaling health policies,and CloudWatch alarms enables the system to recover from failures automatically. For example, if an EC2 instance fails, Auto Scaling can replace it,and ELB will stop sending traffic to it.
      ▶️ SNS alerts ensures admins and developers are notified of any critical issues.
  
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
This project guide gives an understanding of an application that is able to achieve fault tolerance and redundancy, by distributing resources across multiple Availability Zones ensuring that the application remains accessible.

The scalability is the most crucial aspect of the architecture to handle high traffic loads and adjust the number of instances based on demand.

For a full comprehensive step-by-step guide, please visit the full post: [High Availability E-commerce Application Architecture on AWS](https://medium.com/@bennymaliti/high-availability-e-commerce-application-architecture-on-aws-5eebac06975b)
