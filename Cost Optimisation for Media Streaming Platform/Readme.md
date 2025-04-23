## Cost Optimisation and Resource Management for a Media Streaming Platform  
The aim of this project is to analyse at the costs and improve resource management for a media streaming platform hosted on AWS to ensure efficient utilisation of services.    

## 🎯 Objective  
- To analyse the current infrastructure.  
- Identify areas for cost reduction.  
- Propose strategies to achieve cost optimisation goals using AWS services such as  
 * Reserved Instances (RI)  
 * Spot Instances (SI)  
 * Serverless Architectures  
 * AWS Lambda  
 * Amazon S3  
 * Amazon CloudFront  
 * Amazon CloudWatch  
The completion of this project helps in gaining hands-on experience with optimising costs and resource management on AWS and helps drive cost efficiencies for organisations
looking to leveraging cloud infrastructure.  

## 🚀Overview  
- To analyse the existing infrastructure of the media streaming platform and identify opportunities for cost optimisation and resource management.  
- The goal is to reduce unnecessary expenses, improve resource utilisation and leverage AWS services effectively.  

###  **Current Infrastructure Analysis**  
- The first step is to analyse the current infrastructure of the media streaming platform and identify areas where costs can be reduced.  
- This analysis involves examining the usage patterns, resource utilisation and identifying any idle or underutilised resources.  
- We will analyse the utilisation of Amazon EC2 instances and identify opportunities to leverage reserved instances for cost savings.  
- Reseved Instances (RI) allow us to commit specific instance types for a designated period, resulting in discounted hourly rates compared to on-demand instances.  
- Spot Instances (SI) can also be considered for workloads that are tolerant of interruptions and require significant compute resources.  
  By utlising Spot Instances, we can take advantage of unused EC2 capacity at significantly lower prices.  

### **Cost-Saving Strategies**  
- Propose cost-saving strategies such as implementing serverless architecture.  
- Analyse storage and content delivery on Amazon S3 that can be utilised for efficient storage of media files, reducing costs compared to traditional storage solutions.  
- Analyse storage requirements, implement lifecycle policies and optimise storage classes to ensure cost-effective storage management.  
- Improve the performance of content delivery by implementing Amazon CloudFront.    

### **Monitoring and Optimisation**  
- Track the usage and performance of AWS resources by utilising Amazon CloudWatch and Cost Explorer metrics to chart CPU, memory, network I/O and diso I/O over the past 30 - 90 days.  
  
## ♻️🔧Implementation Steps    
1. **Audit & Tagging:**  
- Run **AWS Cost Explorer** to identify top expenses. Tag resources by department/workload (e.g., `Environment: Production`, `Workload : Transcoding`).
- Use **Trusted Advisor** for idle resource checks (e.g., unattached EBS volumes).

2. **EC2 Reserved Instances:**  
- Purchase 3-year RIs for `c5.4xlarge` instances (transcoding cluster) with All Upfront payment (maximum discount).  

3. **Spot Instance Integration:**  
- Deploy Spot Fleets for batch processing with mixed instance types (e.g., `c5.large`, `m5.large`).  
- Use **Spot Block** for 1 - 6 hour jobs.
- Leverage EC2 Spot fleets or Spot Auto Scaling groups, with fallback to On-Demand if Spot capacity is insufficient.
- Use AWS Batch or Amazon Elastic Kubernetes Service with Spot Capacity providers.
  
4. **Serverless Architecture with AWS Lambda:**  
- Rewrite video thumbnail generation as Lambda functions (trigerred by S3 uploads). Set memory to 1024MB (optimised for CPU).
- Migrate stateless microservices or ingestion endpoints to **Lambda functions** behind API Gateway - pay only for actual invocation time.
- Trigger Lambda on S3 uploads for lightweight media metadata extraction or thumbnail generation.
- For heavier workloads, consider **AWS Step Functions** to orchestrate long-running or parallel stacks.
- For best practices, right-size memory allocation to balance cost versus execution time.
- Use provisioned concurrency for latency-sensitive functions, but only where needed.  

5. **Storage Optimisation with Amazon S3:**  
- **Lifecycle Policies:** Apply lifecycle policy to `media bucket` to **transition** infrequently accessed content to **S3 Standard-Infrequent Access (IA)** after 30 days, then to Glacier Deep Archive after 180 days.
- **Media Storage:** Centralise all video files in S3. Ensure you use **S3 Object Lock** or **Versioning** only if compliance requires it.
- **Delete** logs or temporary files automatically after a defined retention period.
- **Cost Tags & Analytics:** Enable **S3 Storage Lens** and **Cost Allocation Tags** to monitor consumption by bucket, prefix and tag.
  
6. **Global Content Delivery with Amazon CloudFront:**  
- Set default TTL to 604800 seconds (7 days) for `/videos/*` path. Enable Brotli compression.
- Enable **Edge Caching** and front the S3 origin (and any API endpoints) with CloudFront distributions.   
  Set the appropriate **cache-control headers** to maximise TTL at edge.
- **Origin Failover:** Configure multiple origins (e.g., primary S3 bucket and fallback origin) for higher availability.
- **Security & Cost Controls:** Enforce HTTPS only, use **AWS WAF** for **DDoS** protection at edge, and monitor **CloudFront** metrics for cache hit ratio (target > 90%).

7. **Monitoring & Ongoing Optimisation with Amazon CloudWatch:**  
- **Metrics & Dashboards:** Build a cost-optimisation dashbaord showing EC2 RI utilisation, Spot interruption rates, Lambda duration, S3 storage tier usage and CloudFront cache hit ratio.
- **Alarms & Automation:** Set alarms on under-utilised RIs (e.g. <60% utilisation over 7 days) to trigger notifications or automated recommendations via **AWS Lambda**.
- **Cost Anomaly Detection:** Enable AWS Anomaly Detection to surface unexpected spikes in service usage or spend.   

## 🎯Expected Outcomes  
### **Cost Reduction**
- 65% savings on EC2 via RIs + Spot.
- 40% storage cost reduction via S3 tiering.
- 30% lower data transfer costs with CloudFront caching.
### **Performance** 
- Improved latency and reduced origin load via CloudFront edge caching.
### **Operational Efficiency and Visibility**
- Automated scaling and serverless workflows reduce manual intervention.
- Proactive alerts driving continuous cost governance.

## ⚠️Risks & Mitigation
- **Spot Interruptions:** Design workflows with checkpointing (e.g., save progress to S3).
- **Lambda Cold Starts:** Use Provisioned Concurrency for critical APIs.
- **S3 Retrieval Costs:** Test Lifecycle policies in staging to avoid unintended Glacier retrievals.

##✔️**Recommendations**  
This project analysed a media-streaming platform AWS services utilisation. By following the above blueprint, it is estimated that the platform will achieve a balance of performance, resilience, and lean AWS spend - freeing budget for future innovation rather than wasteful infrastructure.  

By prioritising Reserved Instances (RI's) and Spot Instances (SI) tiering for immediate savings, followed by **Spot migration** and **Serverless** refactoring.  

It is also recommended to use **Amazon CloudWatch Dashboards** to track progress monthly.  



