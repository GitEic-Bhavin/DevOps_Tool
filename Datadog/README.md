What is Datadog ?
---

Datadog is the essential monitoring and security platform for cloud applications.
It brigns together end-to-end traces, metrics and logs to make Observable of your entire applications, infrastructure and third-party service.

It is an observability service for cloud applications, Providing monitoring of servers, databases, tools and services through a SaaS based data analytics platform.

`It's just a Datadog Agent service will be installed on the application site to collect the metrics and that agent ships those metrics to datadog hosted on cloude.`

- **End-to-End monitoring Solutions** -collection of metrics, alerting system, troubleshooting and build-in dashboard to visualize the metircs.

- Datadog covers wide range of monitoring for:
  - Infrastructure monitoring,
  - Database monitoring,
  - Cloud monitoring,
  - Log monitoring,
  - Application performance monitoring,
  - Real user monitoring,
  - Container monitoring,
  - Security monitoring,
  - Synthetic monitoring.

- Datadog comes with pre-defined dashboards.

- Basic terminology

![alt text](basict.png)

Datadog Architecture
---

![alt text](arc.png)

- In your host the datadog agent is run and responsible for collecting the events, metrics and logs from the host and sending them to data backend to which user interact.

- Based on requirement, the metrics can be filtered, can be grouped and converted to dashboards.

🔹 Components in the Diagram

**1. Host (Server / VM / Container)**

- This is where your application (Python, Java, R, etc.) is running.

- Your code (via libraries, integrations, or APIs) sends metrics and logs to Datadog.

**2. DogStatsD**

- A statsd-compatible service bundled with the Datadog Agent.

- Applications send custom metrics via UDP (fast, low-overhead).

- Example: your app reports response time, errors, or custom counters.

**3. Collector**

- Collects system-level metrics (CPU, memory, disk, network, etc.) from the host.

- Also gathers integration data (databases, Docker, Kubernetes, etc.) using configuration files.

**4. Forwarder**

- Both Collector and DogStatsD send their metrics to the Forwarder.

- The Forwarder prepares the data (batching, compressing, encrypting).

- Communication to Forwarder happens over TCP/HTTP internally.

- **Forwarder will shift the collector's data to the cloud via memory buffer through HTTPS connections**.

**5. Buffer**

- Temporary queue in case of connectivity issues.

- If the Datadog backend is unreachable, data is buffered and retried later.

- **Once the data reached to Datadog backend, users can access to data dog website `https://datadoghq.com` and perform aggregations on that data or filter them to triggers alert to the users and create dashboard.**

**6. Agent**

- The Agent is the overall process running on the host (contains Collector, DogStatsD, Forwarder, Buffer).

- Responsible for collecting, processing, and sending metrics/logs/traces to Datadog.

**7. Datadog Backend**

- Metrics, logs, and traces are sent via HTTPS (port 443) to Datadog’s cloud platform (https://www.datadoghq.com).

- Once there, the data is stored, visualized, and used for dashboards, alerts, and analytics.

**8. User**

- The end user (you) logs into Datadog’s web UI to see dashboards, create monitors, set alerts, and analyze system/application health.

There is 3 more agent works if it is enabled in conf file.

APM Agent - Process to collect traces.
Process Agent - Process to collect live process info.

UI Agent - It is UI Side of data dog agent. If you want to see the datails of Datadog agent in UI, then Datadog provides you UI component which runs directly on the host where the datadog agent is running.

Datadog conf file is located at `/etc/datadog-agent/datadog.yaml`

`/etc/datadog-agent/conf.d/` - contains config files related to integrations that are run on the host where the datadog agent is running.

The metrics coming from the host is divided into 3 apps
1. Agent related metrics
2. ntp metrics
3. system metrics
