# Deployment Guide

## Architecture Summary
A single EC2 instance (t2.micro, Free Tier) in a public subnet runs a Dockerized
Django REST API behind Nginx. Static assets/backups go to S3. CloudWatch collects
system + application logs and metrics. See `ARCHITECTURE.md` for the diagram.

## Prerequisites
- AWS account (Free Tier)
- AWS CLI configured (`aws configure`)
- Terraform >= 1.6
- An existing EC2 key pair (for SSH)
- Docker Hub account (for CI/CD image registry)
- Jenkins instance (can run locally or on a small separate EC2/free service)

## Step 1: Provision Infrastructure

```bash
cd terraform
terraform init
terraform apply \
  -var="key_name=<your-keypair-name>" \
  -var="my_ip=<your-ip>/32"
```

This creates: VPC, public subnet, IGW, route table, security group (80/443 open,
22 restricted to your IP), IAM role (least-privilege: CloudWatch + scoped S3),
S3 bucket (versioned, public access blocked), EC2 instance with Elastic IP.

Note the `instance_public_ip` output — you'll need it for the next steps.

## Step 2: Deploy the Application (manual first run)

```bash
scp -i <key.pem> -r app/ ec2-user@<EIP>:/opt/app
ssh -i <key.pem> ec2-user@<EIP>
cd /opt/app
sudo docker compose up -d --build
```

Verify: `curl http://<EIP>/api/health/` should return `{"status": "ok", ...}`.

## Step 3: Set Up HTTPS (optional but recommended)

If you have a domain pointed at the EIP:
```bash
sudo certbot --nginx -d yourdomain.com
```
Without a domain, Free Tier limits you to HTTP over the raw IP, or you can front
the instance with CloudFront + an ACM cert for HTTPS termination.

## Step 4: Configure CloudWatch

```bash
sudo cp monitoring/cloudwatch-agent-config.json /opt/aws/amazon-cloudwatch-agent/etc/config.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json
```

Then create alarms:
```bash
./monitoring/create_alarms.sh <instance-id>
```

Build a CloudWatch dashboard (Console → CloudWatch → Dashboards) with widgets for:
CPU Utilization, Memory Used %, Network In/Out, and the app log group.

## Step 5: CI/CD Pipeline (Jenkins)

1. In Jenkins, create credentials: `dockerhub-creds` (username/password),
   `ec2-host` (secret text: `ec2-user@<EIP>`), `ec2-ssh-key` (SSH private key).
2. Create a Pipeline job pointing to this repo, script path `jenkins/Jenkinsfile`.
3. On every push to `main`, the pipeline builds the Docker image, runs tests,
   pushes to Docker Hub, and SSHes into EC2 to pull + restart the container.

## Step 6: Load Testing

```bash
cd load-testing
TARGET_URL=http://<EIP> ./run_test.sh
```

Results land in `load-testing/results/`. Pull p95 latency, error rate, and
throughput numbers from `summary.json` into the load testing report.

## Teardown (to avoid charges after submission)

```bash
cd terraform
terraform destroy
```
