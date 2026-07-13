# Activity Solution: Handling the Bank's Monolithic Service Failure

## 1. Restating the Situation

A bank's core RESTful web service application (built as a single monolithic
WAR/JAR) exposes every banking operation — get balance, process loan,
process insurance claim, customer service lookups, ATM transactions, SMS
notifications, IVR queries, EMI deduction jobs, etc.

During the festival season, a huge spike in "get account balance" requests
exposed a **memory leak** in that one operation. The JVM ran out of memory,
new requests were rejected or timed out, and because *everything lives in
the same process*, the failure didn't stay contained:

- Loan agents couldn't submit loan applications.
- Insurance agents couldn't process claim payouts.
- Customer service reps couldn't pull up customer records.
- The only fix was a full server restart, causing 2–3 hours of total downtime
  across **every** banking function, not just the one that was actually broken.

This is the textbook failure mode of a monolith: **one bad line of code in
one feature can bring down the entire enterprise application.**

## 2. Root Cause

| Cause | Effect |
|---|---|
| Single deployable unit (one WAR/JAR) | No isolation between features |
| Shared memory/heap across all operations | A leak in one operation starves all others |
| Shared thread pool / connection pool | Blocked threads on one service block every service |
| No independent scaling | Can't add capacity to just the "get balance" feature during peak load |
| No circuit breaking or bulkheads | Failure cascades instead of being contained |
| Full restart is the only recovery path | Recovery time = downtime for the entire bank, not just one feature |

## 3. Proposed Solution: Decompose the Monolith into Microservices

Split the single application along **business capability boundaries** so
that each service can fail, scale, deploy, and recover independently.

### 3.1 Suggested Service Boundaries

- **Account Service** — balance inquiry, statements, account details
- **Transaction Service** — deposits, withdrawals, transfers
- **Loan Service** — loan applications, approvals, EMI processing
- **Insurance Service** — policy issuance, claims processing, payouts
- **Customer Service** — customer profile, KYC, service requests
- **Notification Service** — SMS/email/push notifications
- **Channel/Gateway Services** — adapters for Mobile App, Net Banking,
  ATM, IVR, Teller application (these call the backend services above,
  they don't implement banking logic themselves)

Each of these becomes its own deployable service, with its own database
(or schema), its own release cycle, and its own scaling policy.

### 3.2 How This Fixes the Incident

| Problem in the Incident | How Microservices Fixes It |
|---|---|
| Memory leak in "get balance" crashed everything | Leak is now confined to the **Account Service** process only; Loan and Insurance services keep running |
| Couldn't scale just the hot path | Spin up more **Account Service** instances behind a load balancer during festival traffic, without touching other services |
| Full restart needed to recover | Only the Account Service instances need restarting/redeploying; a rolling restart avoids downtime entirely |
| No visibility into which feature was failing | Per-service health checks and metrics show exactly which service is unhealthy |
| Long recovery window (2–3 hrs) | Faster MTTR — a single small service restarts in seconds/minutes, and orchestration (e.g. Kubernetes) can auto-restart crashed instances |

### 3.3 Additional Resilience Patterns to Adopt

Splitting into services alone isn't enough — pair it with these patterns:

1. **API Gateway** — single entry point for Mobile App, Net Banking, ATM,
   IVR, Teller clients; routes requests to the correct microservice.
2. **Load Balancing + Horizontal Auto-Scaling** — add more Account Service
   instances automatically when request volume spikes (festival season).
3. **Circuit Breaker Pattern** (e.g. resilience4j/Hystrix-style) — if the
   Account Service starts timing out, the gateway "opens the circuit" and
   fails fast instead of letting requests pile up and exhaust threads.
4. **Bulkhead Pattern** — isolate thread pools/connection pools per service
   so one slow dependency can't exhaust resources needed by others.
5. **Health Checks + Liveness/Readiness Probes** — orchestrator
   automatically restarts an unhealthy Account Service instance without a
   human triggering a full-server restart.
6. **Centralized Monitoring & Alerting** (e.g. Prometheus + Grafana) — catch
   rising memory usage on the Account Service *before* it crashes, instead
   of discovering it only after customer complaints.
7. **Caching** — cache frequently-read, slow-changing data (e.g. account
   balance for a short TTL) to reduce load on the database during peak
   traffic.
8. **Async Notifications** — Notification Service consumes events from a
   message queue (e.g. Kafka/RabbitMQ) instead of being called synchronously,
   so an SMS backlog never blocks a banking transaction.

### 3.4 Migration Approach (Strangler Fig Pattern)

Rather than a risky big-bang rewrite:

1. Identify the highest-risk, highest-traffic capability first — in this
   case, **Account/Balance Service** — and extract it first.
2. Put an API Gateway in front of the existing monolith.
3. Route balance-inquiry traffic to the new Account Service; everything
   else still goes to the monolith.
4. Repeat for Loan, Insurance, Customer Service, etc., one capability at a
   time, until the monolith is "strangled" down to nothing.
5. Each extracted service gets its own database, deployment pipeline, and
   on-call ownership.

## 4. Summary

The incident happened because the bank's application was a **monolith**:
one memory leak in one feature (get balance) took down loan processing,
insurance payouts, and customer service simultaneously, and recovery
required a full outage. Moving to a **microservices architecture** —
decentralized, independently deployable, independently scalable services,
combined with an API Gateway, circuit breakers, health checks, and
monitoring — ensures that a failure in one service (e.g. Account Service)
stays contained to that service, other banking operations continue
uninterrupted, and recovery time drops from hours to minutes.
