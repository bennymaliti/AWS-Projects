## High Availability Architecture for e-commerce Application
In this project, I develop an infrastructure for a high-availability architecture for an ecommerce application. The architecture address the limitations of an ecommerce system that is currently having limitations of the system such as frequent downtime, a lack of fault tolerance, inefficient reource utilisation and having a manual recovery process.

## 🚀 Overview
To achieve high-availability architecture, we will utilise a number of AWS services and components
- Amazon EC2 with Auto Scalling 
      : Redundancy       => Deploy instances across 3 AZ's to eliminate single points of failure.  
      : Scalability      => Auto Scaling to adjust capacity based on CPU/memory usage. (eg. scale out at 70% CPU)
      : Cost Efficiency  => Replace manual scaling with dynamic provisioning
- Application Load Balancer
      : Traffic Distribution : Routes HTTP/HTTPS traffic to healthy instances in multiple AZs.
      : Integration with Auto Scaling : Automatically registers new instances.
