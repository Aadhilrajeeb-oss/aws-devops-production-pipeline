# DevOps Engineer Technical Assignment

Production-like Django REST API deployed on AWS Free Tier with Terraform,
Docker, Jenkins CI/CD, CloudWatch monitoring, and k6 load testing.

## Repo structure
```
terraform/        Infrastructure as code (VPC, EC2, SG, IAM, S3)
app/               Django REST Framework app + Dockerfile + docker-compose
jenkins/           Jenkinsfile (CI/CD pipeline)
monitoring/        CloudWatch agent config + alarm creation script
load-testing/      k6 load test script + runner
docs/              Deployment guide, architecture diagram, security summary,
                   final report template
```

## Quick start
See `docs/DEPLOYMENT_GUIDE.md` for full step-by-step instructions.

```bash
cd terraform && terraform init && terraform apply \
  -var="key_name=<your-key>" -var="my_ip=<your-ip>/32"
```

## Deliverables checklist
- [x] Git repository (this repo)
- [x] Deployment guide - `docs/DEPLOYMENT_GUIDE.md`
- [x] Architecture diagram - `docs/architecture.svg`
- [x] Pipeline configuration - `jenkins/Jenkinsfile`
- [ ] Monitoring screenshots - capture after deployment
- [ ] Load testing report with graphs - run `load-testing/run_test.sh`, fill `docs/FINAL_REPORT_TEMPLATE.md`
- [x] Security summary - `docs/SECURITY_SUMMARY.md`
- [ ] 5-10 min demo video - record after deployment is live
- [ ] Final report (PDF/DOCX) - fill in `docs/FINAL_REPORT_TEMPLATE.md`, export to Word
