# Architecture

See `architecture.svg` for the diagram. Open it in a browser or image viewer,
or embed it in the final report.

## Flow
1. Developer pushes code to the Git repository.
2. Jenkins (triggered by webhook or polling) checks out the repo, builds a
   Docker image of the Django REST API, runs tests, and pushes the image to
   a Docker registry.
3. Jenkins then SSHes into the EC2 instance and pulls + restarts the
   container via `docker compose`.
4. The EC2 instance sits in a public subnet inside a dedicated VPC. A
   security group allows inbound 80/443 from anywhere and restricts SSH
   (22) to a single admin IP.
5. The instance runs Nginx (reverse proxy + HTTPS termination via Certbot)
   in front of the Django app container.
6. The instance's IAM role (least privilege) allows it to write logs/metrics
   to CloudWatch and read/write only its own S3 bucket - no wildcard access.
7. CloudWatch collects CPU/memory/network metrics and application logs,
   feeding dashboards and alarms (high CPU, high memory, failed status
   checks).
8. End users (and the load testing tool) hit the app over HTTPS.

## Why this design for Free Tier
- Single EC2 t2.micro, single AZ, no NAT Gateway or Load Balancer -> avoids
  the main cost drivers while still covering every required capability
  (compute, storage, IAM, security groups, monitoring, CI/CD).
- S3 with versioning + Block Public Access covers the "S3 for static
  assets/backups" requirement without added cost.
- A future scale-up path (documented, not required for this assignment)
  would add: Auto Scaling Group across 2 AZs, an Application Load Balancer,
  and RDS instead of SQLite.
