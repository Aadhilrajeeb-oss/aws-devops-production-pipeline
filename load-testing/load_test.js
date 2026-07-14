import http from 'k6/http';
import { check, sleep } from 'k6';
import { Trend, Rate } from 'k6/metrics';

// Custom metrics for the report
const errorRate = new Rate('errors');
const responseTimeTrend = new Trend('response_time_custom');

export const options = {
  scenarios: {
    ramping_load: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '1m', target: 20 },   // ramp up to 20 users
        { duration: '3m', target: 20 },   // stay at 20
        { duration: '1m', target: 50 },   // ramp up to 50 users
        { duration: '3m', target: 50 },   // stay at 50
        { duration: '1m', target: 0 },    // ramp down
      ],
    },
  },
  thresholds: {
    http_req_duration: ['p(95)<500'],   // 95% of requests under 500ms
    errors: ['rate<0.05'],              // error rate under 5%
  },
};

const BASE_URL = __ENV.TARGET_URL || 'http://<EC2_PUBLIC_IP>';

export default function () {
  const res = http.get(`${BASE_URL}/api/health/`);

  const ok = check(res, {
    'status is 200': (r) => r.status === 200,
  });

  errorRate.add(!ok);
  responseTimeTrend.add(res.timings.duration);

  sleep(1);
}
