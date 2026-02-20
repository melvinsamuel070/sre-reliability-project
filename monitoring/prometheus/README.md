#  SRE Reliability & Observability Project

##  Overview

This project demonstrates a production-grade monitoring and alerting system using:

- Kubernetes (Minikube)
- Prometheus
- Alertmanager
- Grafana
- Custom Node.js application (`sre-app`)

The goal is to simulate real-world Site Reliability Engineering (SRE) practices by monitoring application health, detecting failures, and visualizing system performance.

---

# 🏗 Architecture

User Traffic
     ↓
Kubernetes Deployment (sre-app)
     ↓
Service → Prometheus Scraping (/metrics)
     ↓
Alert Rules
     ↓
Alertmanager
     ↓
Notifications
     ↓
Grafana Dashboards (Visualization)

---

#  Project Goals

- Detect application downtime
- Detect crash loops
- Detect high CPU usage
- Visualize resource consumption
- Understand Kubernetes lifecycle behavior
- Simulate production alerting workflows

---

#  Monitoring Strategy

This project follows production SRE best practices by monitoring:

###  Application Level
- Availability
- Crash loops
- CPU usage

###  Infrastructure Level
- Pod health
- Deployment replica availability
- Resource limits
- Node-level metrics (optional extension)

---

#  Alerting Rules Implemented

##  1. Application Down

Triggers when:
- Available replicas = 0
- Expected replicas > 0

```yaml
- alert: SREAppDown
  expr: |
    kube_deployment_status_replicas_available{deployment="sre-app", namespace="monitoring"} == 0
    AND
    kube_deployment_spec_replicas{deployment="sre-app", namespace="monitoring"} > 0
  for: 30s
  labels:
    severity: critical


Perfect 
I’ll give you a **clean, production-grade README.md** you can copy and paste directly into your project.

No extra explanation. Just ready-to-use.

---

#  README.md

````markdown
#  SRE Reliability & Observability Project

##  Overview

This project demonstrates a production-grade monitoring and alerting system using:

- Kubernetes (Minikube)
- Prometheus
- Alertmanager
- Grafana
- Custom Node.js application (`sre-app`)

The goal is to simulate real-world Site Reliability Engineering (SRE) practices by monitoring application health, detecting failures, and visualizing system performance.

---

# 🏗 Architecture

User Traffic
     ↓
Kubernetes Deployment (sre-app)
     ↓
Service → Prometheus Scraping (/metrics)
     ↓
Alert Rules
     ↓
Alertmanager
     ↓
Notifications
     ↓
Grafana Dashboards (Visualization)

---

#  Project Goals

- Detect application downtime
- Detect crash loops
- Detect high CPU usage
- Visualize resource consumption
- Understand Kubernetes lifecycle behavior
- Simulate production alerting workflows

---

#  Monitoring Strategy

This project follows production SRE best practices by monitoring:

###  Application Level
- Availability
- Crash loops
- CPU usage

###  Infrastructure Level
- Pod health
- Deployment replica availability
- Resource limits
- Node-level metrics (optional extension)

---

#  Alerting Rules Implemented

##  1. Application Down

Triggers when:
- Available replicas = 0
- Expected replicas > 0

```yaml
- alert: SREAppDown
  expr: |
    kube_deployment_status_replicas_available{deployment="sre-app", namespace="monitoring"} == 0
    AND
    kube_deployment_spec_replicas{deployment="sre-app", namespace="monitoring"} > 0
  for: 30s
  labels:
    severity: critical
````

---

##  2. High CPU Usage

Triggers when:

* CPU usage exceeds 80% for 2 minutes

```yaml
- alert: SREAppHighCPU
  expr: |
    sum(rate(container_cpu_usage_seconds_total{pod=~"sre-app-.*", namespace="monitoring"}[1m]))
    /
    sum(kube_pod_container_resource_limits{resource="cpu", pod=~"sre-app-.*", namespace="monitoring"})
    > 0.8
  for: 2m
  labels:
    severity: warning
```

---

##  3. Crash Loop Detection

Triggers when:

* Pod restarts more than 3 times in 5 minutes

```yaml
- alert: SREAppCrashLoop
  expr: |
    increase(kube_pod_container_status_restarts_total{pod=~"sre-app-.*", namespace="monitoring"}[5m]) > 3
  for: 1m
  labels:
    severity: critical
```

---

#  Grafana Dashboards

Connected to Prometheus for:

* CPU usage monitoring
* Memory usage tracking
* Pod health visibility
* Replica scaling observation

Grafana provides real-time visualization of:

* System load
* Resource saturation
* Service lifecycle behavior

---

#  How to Test Alerts

## 1️ Simulate Application Down

```bash
kubectl scale deployment sre-app -n monitoring --replicas=0
```

Expected:

* `SREAppDown` fires after 30 seconds

---

## 2️ Simulate Crash Loop

Modify deployment:

```yaml
command: ["sh", "-c", "exit 1"]
```

Apply:

```bash
kubectl apply -f k8s/
```

Expected:

* `SREAppCrashLoop` fires

---

## 3️ Simulate High CPU

Modify deployment:

```yaml
command: ["sh", "-c", "while true; do :; done"]
```

Expected:

* `SREAppHighCPU` fires after 2 minutes

---

#  Local Environment

* Kubernetes: Minikube
* Driver: Docker
* Namespace: monitoring

Start cluster:

```bash
minikube start --driver=docker
```

---

#  Production-Grade Concepts Demonstrated

* Golden Signals Monitoring
* Health-based alerting (not existence-based)
* Replica awareness
* Crash detection
* Resource saturation monitoring
* Layered alert severity (warning vs critical)
* Observability-first mindset

---

#  Future Improvements

* Horizontal Pod Autoscaler (HPA)
* Slack / PagerDuty integration
* SLO-based alerting
* Node-level monitoring
* Cluster Autoscaler simulation
* Load testing integration
* Chaos engineering scenarios

---

#  Why This Project Matters

This project simulates real production reliability engineering practices.

It demonstrates:

* Understanding of Kubernetes internals
* Alert design strategy
* Observability implementation
* Incident detection workflows
* Production thinking mindset

---

#  Author

Melvin Samuel
DevOps / SRE Engineer
Focused on Reliability, Observability & Production-Grade Systems

