# How the deny rule will affect in NSG ?

- Let look into the belwo NSG Rule

![alt text](denyoutbound.png)

**For Inbound**
- HTTP, SSH is allowed and Deny from 70 - 100 port from anywhere.

**For OutBound**
- Deny from any protocol to dest of VM Private IP 10.0.0.4
- If nginx is installed on VM, Will it visible ?
**Yes** How ?

- While Inbound rule for HTTP is allowed so automatically OutBound Rule will also allowed.

- But Not allowed for VM itself if the VM is sending request (OutBound) to internet to install any of pkg from internet.
- Try to update your software repository, it will not update.


Attach NSG at Subnet Level
---

- This is use while you have same inbound and outbound rule for multiple VMs.
- You can use either Application security group or Attach NSG at Subnet Level.
- Firstly, The Inbound/Outbound rule is varified from Subnet level then it varify at VM NIC Level.

- ![alt text](NSGSub.png)

- App NSG is attached to Subnet level.

- Webapp NSG is attached to VM NIC.

- so first, Subnet level inbond will be varify then it comes to VM NIC level and will be varify.

- Look for inbound rule for Subnet level and VM Level as below

- ![alt text](SubNicRule.png)

- In WebApp NSG the HTTP 80 is not defined. and HTTP 80 is defined in the AppNetwork NSG at subnet level.
- So, Traffic for HTTP request will be denied from VM NIC.
- To allow traffic for HTTP request you have to add HTTP Rule to VM NSG.

![alt text](HTTPVM.png)

Application Security Group
---

- You have multiple Vm and have a same Inbound and Outbound rule in NSG or for specific port request you want to inbound in all VM, you can use ASG.

- create ASG.

![alt text](Asg.png)

- Attache this ASG to VM1 and VM2.

![alt text](attachAsg.png)

- Instead of give the VMs Private IP as dest, use ASG for Dest.

![alt text](AttachASG.png)

**The rule means:**

- Traffic from your IP → allowed to port 80 of any NIC that belongs to ASG1.

- Since VM1’s NIC is in ASG1 → rule applies to VM1.

- So yes, you can access Nginx on VM1 via port 80

![alt text](nginxAsg.png)

- It looks up which NICs are in ASG1 (VM1’s NIC in your case).

- Then it expands the rule to mean: **“Allow traffic from your IP → VM1’s private IP (because NIC is in ASG1) on port 80.”**

Azure Bastion Hosts
---

It is provides secure communications to VMs without the need of Public IP Address.

You can establish RDP and SSH to VMs from Azure Portal.

You will required the Public IP address for **Azure Bastion Hosts** not for VMs.

![alt text](AzureBastions.png)

**Different SKUs for Azure Bastions service**

![alt text](SKUs.png)

- you need a empty subnet for this bastion service.
- in this empty subnet, the bastion will deploy their VMs which will use to connect your VMs in your network privatly via Private IP.

- so you will establish a secure connenction from azure portal on to your bastion's public ip and azure bastions will manage connections internally or privately to your VMs.

![alt text](bastionsarc.png)

- The minimam size of AzureBastionEmptySubnet should /24.
- We have to DisAssociate the public ip of all VM.
- after DisAssociate the Public IP of VM we will not be able to reach that VM via Internet.

- Go to VM1 > Connect > Bastions > Give VMs Credentials > click on Connect

![alt text](connect.png)

- you can connect all vm which are part of that Vnet where the bastions is deployed via bastions service 
- you can't connect to another Vnets VM via bastions without Vnet Peering.
- you have to ensure you had enable Vnet Peering to establish the connection from Bastion Subnet Vnet to Another vnet VM.

**NOTE** - `To make SSH connection via bastions using AZ CLI, you must have to Std or Premium SKUs. Basic SKU supports only from Azure portal.`

User defined routes
---

You want to transfer the pkg1 from sub1 VM1 to sub2 VM2.
How they are trasfering the pkg between subents and its VMs ?
Bydefault there is **Systems Routes** in place which ensure the traffics is routed correctly across the subnets in the Vnets.

But What if your company have a VM hosting a virtual appliance - FireWall and all traffics/pkgs have to be routed through this Virtual Appliance ?

You can define your own routes by **user-defined routes** which will ensure all traffics will routed through this Virtual Appliance.

- Created 2 VM in diff subnet.
- To route the traffic through Appliance, you have to create route table.

![alt text](rt.png)

- Create a new route and mentions the destinations as Dest VMs Subnet CIDR.
- Choose next hope type is Virtual Appliance and its Private IP.

![alt text](newroutes.png)

- Associate this RT to VM1 Subnet due to VM1 want to Route Traffic to VM2.
- Try to ssh from Bastion Host VM to Dest VM VM2.
- It will not connected bcz, The central vm (Virtual Appliance) need to have capability of taking the pkg and forward to next hop dest is VM2.
- For that perform the few stpes

  - Enable IP Forwading for Central VM by Settings > IP Configurations.

![alt text](IpForwarding.png)

  - SSH to Central VM via Bastions and Edit /etc/sysctl.conf enalbe IP Forwarding for IP Version for OS Level.

![alt text](IpFrwOsLevel.png)

  - Restart the Central VM to reload the system conf changes.

Azure Network Watcher
---

- Azure Network Watcher is a service offering tools to monitor, diagnose, and visualize Azure Infrastructure-as-a-Service (IaaS) networks, helping to troubleshoot connectivity and performance issues. 

- Network Watcher has various feature for Monitoring, Traffic analysis and connectivity troubleshooting as below.

![alt text](NetworkWatcher.png)