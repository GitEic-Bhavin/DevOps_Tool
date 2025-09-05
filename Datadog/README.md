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

What is Tagging ?
---

Tags are a way of adding dimensions to datadog telemetries so they can be filtered, aggragated and compared in datadog visualizations.

In Datadog, tagging is the process of attaching key-value metadata (labels) to your metrics, traces, logs, and other monitored data. Tags help you organize, filter, group, and search your data in dashboards, monitors, and alerts.


You can assing tags via Datadog UI , datadog.yaml

By datadog.yaml , write tags anywhere in yaml file

```yaml
tags:
  - "os":"ubuntu"
  - "os-version": "20.04"
```

**Processes**
Datadog’s Live Processes gives you real-time visibility into the processes running on your infrastructure. Use Live Processes to:

- View all of your running processes in one place
- Break down the resource consumption on your hosts and containers at the process level
- Query for processes running on a specific host, in a specific zone, or running a specific workload
- Monitor the performance of the internal and third-party software you run using system metrics at two-second granularity
- Add context to your dashboards and notebooks

Bydefault this live process is disabled, if you have installed datadog-agent 6 or 7 version follow the below steps:

- Edit main config file located at `/etc/datadog-agent/system-probe.yaml`
```yaml
process_config:
  process_collection:
    enabled: true
```

- To apply this changes , restart the datadog agent
```bash
sudo systemctl restart datadog-agent.service
```

![alt text](process.png)

- You can filter the process by tags

![alt text](filtand.png)

- You can filter by AND, OR, !

![alt text](filteror.png)

What is Scrumbing ?
---

- your applications and processes might contain some sensitive data like passwords, access tokens and all, which should not be visible in any of the views on data.

- When the Datadog Agent collects process information (via process_agent), it can capture the full command line used to start processes.

- This command line might contain secrets. Without scrubbing, these secrets could show up in Datadog dashboards, logs, or traces.

- Scrumb will hide this sensitive data and bydefault datadog has enabled this scrumb.
- This is reserved key used by datadog.
![alt text](scrumbstr.png)

**What about custom sensitive words ?**

- Go to main config file and add lines to enable scrumb and our custom sensitive words
```yaml
process_config:
  process_collection:
    enabled: true
    scrub_args: true
    custom_sensitive_words: ['type', 'user']
```

- To create cutome process 
- Click on New metrics and fileter for process, choose metrics name and create

![alt text](cuspr.png)

- But , This is not good approach. bcz this is work at single os level.
- What if you have to monitor all containers running of 100+ Hosts ?

- Here, You have to use Docker-Agent

- For datadog-agent 6+ , pull image from docker hub.
```bash
docker pull datadog/agent
```

- To setup docker-agent you have to pass your DD_API_KEY and DD_SITE.
```bash
docker run -d --cgroupns host --pid host --name dd-agent -v /var/run/docker.sock:/var/run/docker.sock:ro -v /proc/:/host/proc/:ro -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro -e DD_SITE=<DATADOG_SITE> -e DD_API_KEY=<DATADOG_API_KEY> gcr.io/datadoghq/agent:7
```

![alt text](dockeragent.png)

**Metrics Types:**

1. Count - Represents the total number of event occurences in one time interval.
Ex. Total no. of connections made to db

2. Rate - Represents the total number of event occurences in Given Time Interval.

Rate = Total count in the interval / Length of the time interval.

3. Gauge - Gauge takes the last value reported int the interval.
Ex. system.temp[71,71,71,72]
Gauge = system.temp[72]


- Gauge used for measuring values like temperature, current memory usage, the number of active threads.

4. Sets - Sets count the number of unique values passed to a key.

5. Histogram - Represent the statistical distribution of a set of values calculated in one time interval.
- The agent aggregates and generates new metrics using the data of flush interval of 10 sec.
