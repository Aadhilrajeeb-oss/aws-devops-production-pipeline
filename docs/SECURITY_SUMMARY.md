# Security Summary

## IAM
- EC2 instance uses a dedicated IAM role (`devops-assignment-ec2-role`), not
  root or long-lived access keys.
- Role permissions are scoped: `CloudWatchAgentServerPolicy` (AWS managed) for
  metrics/logs, plus a custom inline policy granting `s3:GetObject`,
  `s3:PutObject`, `s3:ListBucket` on only the project's own S3 bucket ARN —
  no wildcard resource access.
- No IAM users with console access were created for the app itself; a
  separate `terraform-admin` IAM user (MFA-enabled, least-privilege) is used
  only for running Terraform from a local machine.

## Network / Firewall
- Security group allows inbound 80 (HTTP) and 443 (HTTPS) from anywhere
  (required for a public web app), but SSH (22) is restricted to a single
  admin IP (`var.my_ip`), not `0.0.0.0/0`.
- All other inbound ports are closed by default (SG default-deny).
- Outbound traffic is unrestricted to allow package installs, Docker pulls,
  and CloudWatch/S3 API calls.

## Data
- S3 bucket has Block Public Access enabled on all four settings.
- Versioning is enabled on the S3 bucket to protect against accidental
  overwrite/deletion.
- No secrets (DB passwords, API keys) are hardcoded in source; they are
  passed via environment variables / Jenkins credentials store.

## Application
- `DEBUG=false` in production settings to avoid leaking stack traces.
- `ALLOWED_HOSTS` is configurable via environment variable rather than
  hardcoded to `*` in the deployed config.
- Gunicorn runs as a non-root process inside the container.

## Transport
- HTTPS is configured via Certbot/Let's Encrypt (or CloudFront + ACM as an
  alternative) so credentials and data are not sent in plaintext.

## CI/CD
- Jenkins credentials (Docker Hub login, EC2 SSH key) are stored in the
  Jenkins credentials store, not in the Jenkinsfile or repo.
- Docker images are tagged with the Jenkins build number for traceability
  and rollback, in addition to `latest`.

## Known Gaps (documented honestly for the assignment)
- No WAF or rate-limiting layer in front of the app (would add AWS WAF or
  Nginx `limit_req` in a real production setup).
- No automated vulnerability scanning of the Docker image (would add Trivy
  or ECR image scanning in a follow-up iteration).
- Single AZ, single instance — no high availability (acceptable trade-off
  for Free Tier scope of this assignment).
