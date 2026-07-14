#!/bin/bash
# Usage: TARGET_URL=http://<EC2_IP> ./run_test.sh
# Requires k6 installed: https://k6.io/docs/get-started/installation/

mkdir -p results

k6 run \
  --out json=results/raw_results.json \
  --summary-export=results/summary.json \
  load_test.js

echo "Done. Raw results in results/raw_results.json, summary in results/summary.json"
echo "Use results/summary.json to pull p95 latency, throughput, error rate for your report."
