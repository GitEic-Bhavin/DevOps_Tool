# Azure Monitor
- This service allows you to collect data for your azure resources and your on-premises resouces as well.

- You can analyze the data.

- You can look at the metrics collected for variouse resources.
- you can get insights when it comes to resurces such as virutal machines
- alerts can be genereated if metrics for resources got beyond a particular threshold.
- you can also collect the applications logs.
- you can get reports and even visualize the data.

Create Alert
---

Go to Azure Monitor > Alerts > Create Alert Rule

Selece Scope for resource like sub level, RG Level or Resource level. I will select VM1.

Condition - You can create alert for various signal like Percentage CPU, Available Memory Bytes ( Metics level ) and also select at Activity Log.

![alt text](alert-condition.png)

Set the CPU Percentage Threshold

- You have to create Action Group for what to do while alert triggered.
- Choose Notification types - Email/SMS/Push notifications/Voice call.

![alt text](actionGroup.png)

- Put your email for email notifications, put your mobile number for Voice Call or SMS notifications.

- If you are using Azure App notification in your mobile you can choose Push notifications.

- Go to Actions - Here you can choose what to do within azure resouce while alert triggerd like it should be if VM CPU reaches above 80% then Azure Function should run to Restart the VM.

![alt text](actions.png)

Supressing the Alerts
---

While you have pre-planned maintenance, Upgradations plans, at that time your app, services will may down and cause outage for that you already created alert.

But during upgradation time you don't want to receive alert, you can do it by **Suppression alert**.

Log analytics workspace
---

This will stores all your resources, applications data, metrics, logs etc as central place.

To received the resources logs, metrics etc to this Log analytics workspace, you have to create **Data collectin rule** where you can define source as your various azure resouces and dest as **Log analytics workspace**.

![alt text](Dcr.png)