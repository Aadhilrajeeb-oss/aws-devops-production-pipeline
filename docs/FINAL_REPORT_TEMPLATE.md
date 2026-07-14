# Final Report - DevOps Engineer Technical Assignment

**Candidate:** Muhammed Aadhil Rajeeb
**GitHub:** github.com/Aadhilrajeeb-oss
**Date:** [fill in submission date]

## 1. Objective
[1-2 sentences restating the goal in your own words: deploy, secure, monitor
a production-like app on AWS Free Tier with CI/CD and load testing.]

## 2. Architecture
[Paste architecture.svg image here, or describe it. Reference docs/ARCHITECTURE.md.]

## 3. Infrastructure Setup
- VPC, subnet, route table, IGW provisioned via Terraform (link to terraform/ folder)
- EC2 t2.micro (Free Tier eligible) running Dockerized Django REST API
- S3 bucket for [static assets / backups] - versioned, public access blocked
- [Fill in: actual instance ID, region, any deviations from plan]

## 4. Security
See `docs/SECURITY_SUMMARY.md` for full detail. Summary:
- IAM least privilege (scoped S3 policy, no wildcard resources)
- SSH restricted to admin IP; only 80/443 open publicly
- HTTPS via [Certbot / CloudFront+ACM]
- [Fill in: any additional measures you implemented]

## 5. CI/CD Pipeline
- Tool used: Jenkins (Jenkinsfile in `jenkins/Jenkinsfile`)
- Pipeline stages: checkout -> build -> test -> push -> deploy
- [Fill in: screenshot of a successful pipeline run, build number, timing]

## 6. Monitoring
- CloudWatch agent config: `monitoring/cloudwatch-agent-config.json`
- Alarms: high CPU (>70%), high memory (>80%), status check failed
- Dashboard: [attach screenshot]
- Logs collected: bootstrap log, container logs

## 7. Load Testing
- Tool: k6 (`load-testing/load_test.js`)
- Test profile: ramp 0->20->50 virtual users over ~9 minutes
- **Results table** (fill in from `load-testing/results/summary.json`):

| Metric | Value |
|---|---|
| p95 latency | [fill in] ms |
| Average response time | [fill in] ms |
| Throughput (req/s) | [fill in] |
| Error rate | [fill in] % |
| CPU utilization (peak) | [fill in] % (from CloudWatch) |
| Memory utilization (peak) | [fill in] % (from CloudWatch) |

- [Attach graph: response time over time, from k6 or Grafana/CloudWatch]

## 8. Bottleneck Analysis & Optimization Suggestions
[Fill in based on actual results, e.g.:]
- If p95 latency spikes under 50 VUs: single t2.micro CPU credits may be
  exhausting -> suggest t3.small with unlimited burst, or add a second
  instance behind an ALB.
- If error rate rises with load: gunicorn worker count (currently 3) may be
  too low for concurrent load -> tune `--workers` and `--threads`.
- SQLite is not designed for concurrent writes at scale -> migrate to RDS
  (Postgres, Free Tier eligible db.t3.micro) for a real production setup.

## 9. Challenges Faced
[Fill in honestly - e.g. AMI region availability, SSH key issues, Jenkins
credential setup, HTTPS without a domain, etc.]

## 10. Improvements for the Future
- Multi-AZ with Auto Scaling Group + ALB for high availability
- Move from SQLite to RDS
- Add AWS WAF / rate limiting
- Add automated image vulnerability scanning (Trivy) to the pipeline
- Infrastructure drift detection (`terraform plan` in CI on a schedule)

## Appendix: Deliverables Index
- Git repository: [link]
- Deployment guide: `docs/DEPLOYMENT_GUIDE.md`
- Architecture diagram: `docs/architecture.svg`
- Pipeline config: `jenkins/Jenkinsfile`
- Monitoring screenshots: [attach]
- Load testing report: `load-testing/results/`
- Security summary: `docs/SECURITY_SUMMARY.md`
- Demo video: [link]
