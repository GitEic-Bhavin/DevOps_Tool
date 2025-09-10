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


**Customer Metrics**
- Customer metrics are useful in monitoring critical applications KPIs like:

  - No. of visitors on website.
  - Avg customer cart size.
  - Request latency.
  - Performance distributions.

**Customer Metrics Properties**
- **Metric Name** - Name of the custom metrics.
- **Metric Values** - Value of cusom metrics. Must be 32-bit and should not reflect dates or timestamps.

- **TimeStamp** - Can't be more than 10 minutes in the future or more than 1 hr in the past.

- **Tags** - Tags associated to the metrics.
- **Metric Type** - can be count, rate, gauge, set, histogra, or distributions.

- **Interval** - Flush interval for rate and count type.

**Custom Metrics Submission Type**
- Custom metrics can be sent to datadog using multiple submission types.

- There are 4 submission types
**1. Agent Check** - You can submit metrics like count, gauge, rate, histogram.
**2. DogstatsD** -
**3. Powershell** - 
**4. API** - 

  - **Count** - To submit count type metrics, `monotonic count` or `count function` is used.
  - `monotonic count()` - Used to track a new COUNT metrics that **Always increases**.
  - Sample that have a lower value than the previous samples are ingnored.
  - `count` is used to represent the metrics like - **No. of requests served, task completed or errors encountered.**

  - Stored with a COUNT Mertics type in datadog.

  `monotonic count functions template`

```bash
self.monotonic_count(name, value, tags=None, hostname=None, device_name=None)
```

- Examples: First execution [3,5,9] -- (9-3)=6 , Second executions [10,11] -- (11-9) =2.

  `count function` - **count()** - Submit the **No. of events** that occured during that check interval.

  - Ex. First Execution [3,5,9] -- 3
        Second Execution [10,11] -- 2
  `count function` - 
```bash
self.count(name,value,tags=None, hostname=None, device_name=None)
```

- A custom metric in Datadog is not just the metric name.
It’s identified by: `metric_name + all tag value combinations`

- So if you change a tag’s value, Datadog considers it a different custom metric.
- Suppose you emit this metric in your Python check: `self.count("file.modified.count", 5, tags=["env:prod", "region:us"])`  → counts as 1 custom metric.

- If you assing multiple tags:
- Even though the metric name is the same (file.modified.count), you have 3 unique tag sets → 3 custom metrics.
```py
file.modified.count{env:prod, region:us}
file.modified.count{env:prod, region:eu}
file.modified.count{env:dev, region:us}
```


What if you want to query only that metrics having new tags and remaining all other tags shall be non variable.
---

- At this time, you have to index that new tags to keep it variable for this mertics and remaining all other tags will be non-variables.

- Choose custom metrics on datdog UI
- Click on mamanged tags

![alt text](mtag.png)

- Choose new tags from include tags

![alt text](itag.png)

- If you want to **index a bulk of tags**, go to **Configure Metrics** and choose your tags

![alt text](btag.png)


- **Rate()**

![alt text](ratem.png)

- To create custom_rate metrics
- add custom_rate.yaml at /etc/datadog-agent/checks.d/custom_rate.py

- There are 2 ways to submit our custom metrics to datadog.
- This is the `1st way` of submit our custom metrics using **Agent check** in py.
- add /etc/datadog-agent/conf.d/custom_rate.d/custom_rate.yaml
```yml
init_config:

instances:
  - min_collection_interval: 60
```
- restart the datadog-agent
```bash
sudo systemctl restart datadog-agent
```

![alt text](rateop.png)


- **Histogram**

- Use this function to create histogram
```py
self.histogram(name,value,tags=None,hostname=None,device_name=None)
```

- The `2nd way` of submit our custom metrics is using **`DogstatsD`**.

- To submit our custom metrics we will use python web applications code.

```py
import http.server

APP_PORT = 81

class HandleRequests(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><head><title>First Application</title></head><body style='color: #333; margin-top: 30px;'><center><h2>Welcome to Datadog-Python application.</center></h2></body></html>", "utf-8"))

if __name__ == "__main__":
    server = http.server.HTTPServer(('localhost', APP_PORT), HandleRequests)
    server.serve_forever()
```

- **DogstatsD Metircs supported** is
  - count
  - Gauge
  - Set
  - Timer
  - Histogram
  - Distributions

DogstatsD - Count
---

**Increment()**
- Used to increment a COUNT metric.
- Used to represents **Monotonically increasing** counter whose value **Can only increase** or it can be **reset to zero on restart**.
- Use cases - **Number of requests served, task completed or errors encountered**.

```bash
increment(<METRIC_NAME>,<SAMPLE_RATE>,<TAGS>)
```

- Sample rate specifies **What percent of generated metrics are sent to Datadog**.

**decrement()**
- Used to decrement a COUNT Metrics.

```bash
decrement(<METRIC_NAME>,<SAMPLE_RATE>,<TAGS>)
```

Now, add or make instrumentation to our web app for DogstatsD
---

```py
import http.server
from datadog import initialize, statsd # This is added

APP_PORT = 81
options = {'statsd_host':'localhost', 'statsd_port':8125} # Bydefault, DogstatsD is enabled over Port 8125

class HandleRequests(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        statsd.increment('app.http.request.count', sample_rate=1, tags=["env:dev", "app:pythonapp"]) # This is we instrumented our apps, to serve the total requests counts.
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><head><title>First Application</title></head><body style='color: #333; margin-top: 30px;'><center><h2>Welcome to Datadog-Python application.</center></h2></body></html>", "utf-8"))

if __name__ == "__main__":'
    initialize(**options)
    server = http.server.HTTPServer(('localhost', APP_PORT), HandleRequests)
    server.serve_forever()
```

- You have to install datadog library for pythons.
```bash
sudo pip install datadog
```

- Run this py script and look into Datadog UI for custom metrics `app.http.request.count`.


Event Monitoring
---

- Events represents a notable change in the state of a monitored applications or devices.

- Examples:
  - Error or exception generated by the apps.
  - Performance threshold corss.
  - Conf. chages in the env.
  - Operational change in the apps such as JVM restart.

- Events are generated from **Datadog agent, 100+ Supported integrations and custom events**.

**Datadog agent** - automatically gathers events from the hosts without any additional setup.

**Custom events** - You can submit your own custom events using the Datadog API, Custom Agent check and DogstatsD.

- To collect the logs from specific dir , you have to create logs.d/conf.yaml at /etc/datadog-agnet/conf.d/logs.d/conf.yaml

```yml

logs:
  - type: file
    path: /var/log/syslog
    source: syslog
    service: system
    tags:
      - env:prod
      - os:linux

  - type: file
    path: /var/log/auth.log
    source: syslog
    service: auth
    tags:
      - env:prod
      - os:linux
# log_enabled: true
# This will enabled logs at globale level.

```

- This will send the logs from syslog and auth.log to datadog.

- Go to Datadog UI > Logs > Live Tail.
- Click to Get started.

![alt text](lt.png)



Create Custom Events
---

- Go to checks.d/cusomt_event.py
```py
from datadog_checks.base import AgentCheck
import os, time

__version__="1.0.0"

class DEMOCM(AgentCheck):
    def check(self, instance):
        
        count=0
        dir_path = "/home/einfochips/custom_gauge/test/"
        
        for path in os.listdir(dir_path):
            if (int(time.time()) - int(os.path.getctime(os.path.join(dir_path, path))) < 60):
                count+=1
                
        print(count)
        
        self.count("file.modified.count", count, tags=["env:local", "app:file_modify_count"], )
        self.event({
            "timestamp": time.time(), "event_type": "Info", "msg_title": "Example event","alert_type": "info"
        })
```

- Look into UI for All Events
- you will see `Example Events`

![alt text](cevent.png)

- This is done by agent check , to done by DogstatsD use app/ in datadog-agent/

```py
import http.server
from datadog import initialize, statsd # This is added

APP_PORT = 81
options = {'statsd_host':'localhost', 'statsd_port':8125} # Bydefault, DogstatsD is enabled over Port 8125

class HandleRequests(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        statsd.increment('app.http.request.count', sample_rate=1, tags=["env:dev", "app:pythonapp"]) # This is we instrumented our apps, to serve the total requests counts.
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><head><title>First Application</title></head><body style='color: #333; margin-top: 30px;'><center><h2>Welcome to Datadog-Python application.</center></h2></body></html>", "utf-8"))

        statsd.event(title='Request completed', message='A new msg got completed',alert_type='info', tags=['env:dev'])

        # This is added for custom event.


if __name__ == "__main__":
    initialize(**options)
    server = http.server.HTTPServer(('localhost', APP_PORT), HandleRequests)
    server.serve_forever()
```

- Restart agent

- Go to UI for all events.
![alt text](event.png)


Notebooks
---

- Notebook are Interactive editor for graphing and story-telling in datadog.

- Combine graphs and text in a linear, cell-based formate.

- They help you to explore and share storis with your data by:

  - creating post-mortems,
  - investigations,
  - Runbooks,
  - Documentations,
  - Incident reports,
  - Gameday Outline

![alt text](nb.png)

Monitor and Alerts
---

There are multiple types of monitor like Host, Metrics, Forecast, APM etc.

- To create alert for monitor your Datadog-agent host for trigger alert while this host is down and send email.

- Create Host alerts.

- Edit hostname if it contains words like `new` , `dev`.
- Use {{#is_match}} for select hostname should match with words like new and dev.

![alt text](hosts.png)

- Write msg and send email.

![alt text](wmsg.png)

- Renotify msg till 2 times occurs.

![alt text](rnotify.png)

Logs Collections
---

- Log management is the practice of continuously gathering, storing, processing and analyzing data from varied programs and apps.

- Datadog's Log Management Service **Collects logs across multiple logging sources** - server, container, cloud, apps etc.

**Logging without Limits**
- You are charged for the volume of logs you send to LMS.
- One way to reduce the cost is To Filter the logs before sending them to Servers.

**Datadog Solutions** - Removes this limitations by `decoupling the log ingestion process` from indexing which is known as `logging without limits`.

- You have to configure your logs by choosing which ones to index, retain or archive.


Go to Datadog UI > Logs > Choose Python app as source logs.

create `python.d` at /etc/datadog-agent/conf.d/conf.yaml

```yml
#Log section
logs:

    # - type : file (mandatory) type of log input source (tcp / udp / file)
    #   port / path : (mandatory) Set port if type is tcp or udp. Set path if type is file
    #   service : (mandatory) name of the service owning the log
    #   source : (mandatory) attribute that defines which integration is sending the log
    #   sourcecategory : (optional) Multiple value attribute. Can be used to refine the source attribute
    #   tags: (optional) add tags to each log collected

  - type: file
    path: "/path/to/python-app/Python_Logging/log.json"
    service: myapplication
    source: python
    sourcecategory: sourcecode
    #For multiline logs, if they start with a timestamp with format yyyy-mm-dd uncomment the below processing rule
    #log_processing_rules:
    #   - type: multi_line
    #     pattern: \d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])
    #     name: new_log_start_with_date
```

- Create your python app in directory of `Python_Logging`
```py
if __name__ == '__main__':
    from selenium.webdriver.common.by import By
    from selenium.webdriver.support.ui import WebDriverWait
    from selenium.webdriver.support import expected_conditions as EC
    import undetected_chromedriver as uc
    import logging
    from pythonjsonlogger import jsonlogger 

    # Chrome options
    options = uc.ChromeOptions()
    options.add_argument("--incognito")
    driver = uc.Chrome(options=options)   # Linux: no executable_path needed
    driver.maximize_window()

    # logging setup
    logger = logging.getLogger()
    logHandler = logging.FileHandler(filename='/path/to/python-app/Python_Logging/log.json')
    formatter = jsonlogger.JsonFormatter()
    logHandler.setFormatter(formatter)
    logger.addHandler(logHandler)
    logger.setLevel(logging.INFO)

    try:
        driver.get("https://www.amazon.com/")

        # Wait up to 10s for product element
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.XPATH, "//div[contains(@class,'product')]"))
        )
        logger.info("Product element found", extra={"referral_code": "79vn4et"})

    except Exception as e:
        logger.info("Product not found in website", extra={"referral_code": "79vn4et"})
        logger.error(str(e))

    input("Press Enter to close browser...")  # Keeps browser open for inspection
    driver.quit()
```

create log.json file to store your python apps logs.

Run this apps.

This will sends your python apps logs to your datadog.

![alt text](enablelog.png)

Live Tails
---

- It will gives you all logs like excluded, included.
- It will very usefull while live deployment, changes etc. At this time you can see all logs.

![alt text](gbyf.png)

- Group by Patterns for all logs which will group of same patterns like error, exceptions etc.

![alt text](gbyp.png)

- Group by Transactions - Will aggregate the index logs according to sequence of events such as a user session or a request processed  across multiple microservices.

Integrations
---

There are 3 types of integrations

1. Agent-based
2. Authentication-based(Crawler)
3. Library

1. Agent-based
- Installed with Datadog Agent.
- Uses python class method called **check** to define the metrics to collect.
- This includes Activemq, Airflow, Cassandra etc.

2. Authentication-based (Crawler)
- You proivde **Credentials** for obtaining metrics with the API.
- This includes Slack, AWS, Azure, GCP and PagerDuty.

3. Library
- Use the Datadog API to allow monitoring apps based on the language they are writtern in.
- Node.js or Pythons.


APM Setup
---

- Setting up Datadoh IPM Across hosts , containers pr serverless functions.

Step1 - Conf the datadog agent for APM. - Datadog.yaml file present in root directory.
Enabled it from datadog.yaml by uncomment it.
```yaml
# apm_config:

  ## @param enabled - boolean - optional - default: true
  ## @env DD_APM_ENABLED - boolean - optional - default: true
  ## Set to true to enable the APM Agent.
  #
  # enabled: true
```
**Datadog APM Agent port is listions on port 8126**

Step2 - Add datadog tracing lib to code.

You need to install `ddtrace`
```bash
pip install ddtrace
```

This will automatically instrument your apps.
You have to run your apps with ddtrace

```bash
ddtrace-run python3 <Your_Python.py>
```

Profiling
---

- Profiler shows How much work each function in your code is doing.

- goes deeper inside your code and shows how much CPU time / memory each function in your code is using.

- If your apps spikes at 80% cpu. This profiling will find which functios cause it to spike 80% of cpu or more memroy usgae etc.

UI Monitor
---

**Real User Monitoring (RUM)**
- It captures and analuzes the transaction done by users on a website or apps.
- It will collects detailed data about a user's interaction with an apps. Ex - Page load events, HTTP requests, Frontend Apps Crashes.

- Real world ex: 
  - Assess the current speed of website
  - E-commerce websites track user activity to identify the reasons of incomplete orders.

  - Login failures.

How RUM Works ?
---

- Add the script which will install Datadog RUM SDK to Frontend Code like in html frontend file.

- While user made a request to your apps, it will auto installed this RUM SDK on that user's device.

- Then it will start to collecting data and sending to datadog server.

- Go to real user monitoring > create new apps.

- Select your apps like Js, Flutter etc
- Give env as dev and choose CDN Sync for faster page load.

- It will create RUM SDK Installation script.

![alt text](rum.png)

- To see which type of data collected by RUM SDK .
- Go to RUM Explorer and see it

![alt text](rumexp.png)

