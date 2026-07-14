#!/bin/bash
# Run this after the EC2 instance is up. Requires AWS CLI configured.
# Usage: ./create_alarms.sh <instance-id> <sns-topic-arn>

INSTANCE_ID=$1
SNS_TOPIC_ARN=$2

if [ -z "$INSTANCE_ID" ]; then
  echo "Usage: $0 <instance-id> [sns-topic-arn]"
  exit 1
fi

ALARM_ACTIONS=""
if [ -n "$SNS_TOPIC_ARN" ]; then
  ALARM_ACTIONS="--alarm-actions $SNS_TOPIC_ARN"
fi

# High CPU alarm
aws cloudwatch put-metric-alarm \
  --alarm-name "devops-assignment-high-cpu" \
  --namespace "AWS/EC2" \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --statistic Average \
  --period 300 \
  --threshold 70 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2 \
  $ALARM_ACTIONS

# High memory alarm (custom metric from CW agent)
aws cloudwatch put-metric-alarm \
  --alarm-name "devops-assignment-high-memory" \
  --namespace "DevOpsAssignment" \
  --metric-name mem_used_percent \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2 \
  $ALARM_ACTIONS

# Status check failed alarm
aws cloudwatch put-metric-alarm \
  --alarm-name "devops-assignment-status-check-failed" \
  --namespace "AWS/EC2" \
  --metric-name StatusCheckFailed \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --statistic Maximum \
  --period 60 \
  --threshold 1 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --evaluation-periods 2 \
  $ALARM_ACTIONS

echo "Alarms created for instance $INSTANCE_ID"
