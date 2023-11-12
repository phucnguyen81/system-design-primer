# Design a system that scales to millions of users on AWS

_Note: This document links directly to relevant areas found in the [system design topics](/#index-of-system-design-topics) to avoid duplication. Refer to the linked content for general talking points, tradeoffs, and alternatives._

## Step 1: Outline use cases and constraints

> Gather requirements and scope the problem.
> Ask questions to clarify use cases and constraints.
> Discuss assumptions.

Without an interviewer to address clarifying questions, we'll define some use cases and constraints.

### Use cases

Solving this problem takes an iterative approach of:

1. **Benchmark/Load Test**
2. **Profile** for bottlenecks
3. address bottlenecks while evaluating alternatives and trade-offs
4. repeat, which is good pattern for evolving basic designs to scalable designs

<div class="container medium center">
```mermaid!
flowchart TD
A[Current Design] -->|run benchmarks/load tests| B{Find bottlenecks}
B -->|address bottlenecks| F[New Design]
B -->|identify trade-offs| F
B -->|evaluate alternatives| F
F -->|repeat| A
```
</div>

Unless you have a background in AWS or are applying for a position that requires AWS knowledge, AWS-specific details are not a requirement. However, **much of the principles discussed in this exercise can apply more generally outside of the AWS ecosystem.**

#### We'll scope the problem to handle only the following use cases

- **User** makes a read or write request
  - **Service** does processing, stores user data, then returns the results
- **Service** needs to evolve from serving a small amount of users to millions of users
  - Discuss general scaling patterns as we evolve an architecture to handle a large number of users and requests
- **Service** has high availability

### Constraints and assumptions

#### State assumptions

- Traffic is not evenly distributed
- Need for relational data
- Scale from 1 user to tens of millions of users
  - Denote increase of users as:
    - Users+
    - Users++
    - Users+++
    - ...
  - 10 million users
  - 1 billion writes per month
  - 100 billion reads per month
  - 100:1 read to write ratio
  - 1 KB content per write

#### Calculate usage

**Clarify with your interviewer if you should run back-of-the-envelope usage calculations.**

- 1 TB of new content per month
  - 1 KB per write \* 1 billion writes per month
  - 36 TB of new content in 3 years
  - Assume most writes are from new content instead of updates to existing ones
- 400 writes per second on average
- 40,000 reads per second on average

Handy conversion guide:

- 2.5 million seconds per month
- 1 request per second = 2.5 million requests per month
- 40 requests per second = 100 million requests per month
- 400 requests per second = 1 billion requests per month

## Step 2: Create a high level design

> Outline a high level design with all important components.

See [the original image](http://i.imgur.com/B8LDKD7.png).

<div class="container center small">
```mermaid!
graph
  Client-->DNS
  Client-->WebServer[Web Server]
  style Client fill:LightGreen
  style DNS fill:Magenta
  style WebServer fill:LightBlue
```
</div>

## Step 3: Design core components

> Dive into details for each core component.

### Use case: User makes a read or write request

#### Goals

- With only 1-2 users, you only need a basic setup
  - Single box for simplicity
  - Vertical scaling when needed
  - Monitor to determine bottlenecks

#### Start with a single box

- **Web server** on EC2
  - Storage for user data
  - [**MySQL Database**](/#relational-database-management-system-rdbms)

Use **Vertical Scaling**:

- Simply choose a bigger box
- Keep an eye on metrics to determine how to scale up
  - Use basic monitoring to determine bottlenecks: CPU, memory, IO, network, etc
  - CloudWatch, top, nagios, statsd, graphite, etc
- Scaling vertically can get very expensive
- No redundancy/failover

_Trade-offs, alternatives, and additional details:_

- The alternative to **Vertical Scaling** is [**Horizontal scaling**](/pages/load-balancer#horizontal-scaling)

#### Start with SQL, consider NoSQL

The constraints assume there is a need for relational data. We can start off using a **MySQL Database** on the single box.

_Trade-offs, alternatives, and additional details:_

- See the [Relational database management system (RDBMS)](/#relational-database-management-system-rdbms) section
- Discuss reasons to use [SQL or NoSQL](/pages/sql-or-nosql)

#### Assign a public static IP

- Elastic IPs provide a public endpoint whose IP doesn't change on reboot
- Helps with failover, just point the domain to a new IP

#### Use a DNS

Add a **DNS** such as Route 53 to map the domain to the instance's public IP.

_Trade-offs, alternatives, and additional details:_

- See the [Domain name system](/pages/domain-name-system) section

#### Secure the web server

- Open up only necessary ports
  - Allow the web server to respond to incoming requests from:
    - 80 for HTTP
    - 443 for HTTPS
    - 22 for SSH to only whitelisted IPs
  - Prevent the web server from initiating outbound connections

_Trade-offs, alternatives, and additional details:_

- See the [Security](/#security) section

## Step 4: Scale the design

> Identify and address bottlenecks, given the constraints.

### Users+

The original image is [here](http://i.imgur.com/rrfjMXB.png).

<div class="container center small">
```mermaid!
graph TD
Client[Client] --> DNS[DNS]
DNS --> WebServer[Web Server]
WebServer --> SQL[(SQL)]
WebServer --> ObjectStore[(Object Store)]
style Client fill:LightGreen
style DNS fill:SkyBlue
style WebServer fill:Magenta
style SQL fill:Gold
style ObjectStore fill:Gold
```
</div>

#### Assumptions

Our user count is starting to pick up and the load is increasing on our single box. Our **Benchmarks/Load Tests** and **Profiling** are pointing to the **MySQL Database** taking up more and more memory and CPU resources, while the user content is filling up disk space.

We've been able to address these issues with **Vertical Scaling** so far. Unfortunately, this has become quite expensive and it doesn't allow for independent scaling of the **MySQL Database** and **Web Server**.

#### Goals

- Lighten load on the single box and allow for independent scaling
  - Store static content separately in an **Object Store**
  - Move the **MySQL Database** to a separate box
- Disadvantages
  - These changes would increase complexity and would require changes to the **Web Server** to point to the **Object Store** and the **MySQL Database**
  - Additional security measures must be taken to secure the new components
  - AWS costs could also increase, but should be weighed with the costs of managing similar systems on your own

#### Store static content separately

- Consider using a managed **Object Store** like S3 to store static content
  - Highly scalable and reliable
  - Server side encryption
- Move static content to S3
  - User files
  - JS
  - CSS
  - Images
  - Videos

#### Move the MySQL database to a separate box

- Consider using a service like RDS to manage the **MySQL Database**
  - Simple to administer, scale
  - Multiple availability zones
  - Encryption at rest

#### Secure the system

- Encrypt data in transit and at rest
- Use a Virtual Private Cloud
  - Create a public subnet for the single **Web Server** so it can send and receive traffic from the internet
  - Create a private subnet for everything else, preventing outside access
  - Only open ports from whitelisted IPs for each component
- These same patterns should be implemented for new components in the remainder of the exercise

_Trade-offs, alternatives, and additional details:_

- See the [Security](/#security) section

### Users++

![Imgur](http://i.imgur.com/raoFTXM.png)

#### Assumptions

Our **Benchmarks/Load Tests** and **Profiling** show that our single **Web Server** bottlenecks during peak hours, resulting in slow responses and in some cases, downtime. As the service matures, we'd also like to move towards higher availability and redundancy.

#### Goals

- The following goals attempt to address the scaling issues with the **Web Server**
  - Based on the **Benchmarks/Load Tests** and **Profiling**, you might only need to implement one or two of these techniques
- Use [**Horizontal Scaling**](/pages/load-balancer#horizontal-scaling) to handle increasing loads and to address single points of failure
  - Add a [**Load Balancer**](/#load-balancer) such as Amazon's ELB or HAProxy
    - ELB is highly available
    - If you are configuring your own **Load Balancer**, setting up multiple servers in [active-active](/#active-active) or [active-passive](/#active-passive) in multiple availability zones will improve availability
    - Terminate SSL on the **Load Balancer** to reduce computational load on backend servers and to simplify certificate administration
  - Use multiple **Web Servers** spread out over multiple availability zones
  - Use multiple **MySQL** instances in [**Master-Slave Failover**](/#master-slave-replication) mode across multiple availability zones to improve redundancy
- Separate out the **Web Servers** from the [**Application Servers**](/#application-layer)
  - Scale and configure both layers independently
  - **Web Servers** can run as a [**Reverse Proxy**](/pages/reverse-proxy-web-server)
  - For example, you can add **Application Servers** handling **Read APIs** while others handle **Write APIs**
- Move static (and some dynamic) content to a [**Content Delivery Network (CDN)**](/#content-delivery-network) such as CloudFront to reduce load and latency

_Trade-offs, alternatives, and additional details:_

- See the linked content above for details

### Users+++

![Imgur](http://i.imgur.com/OZCxJr0.png)

**Note:** **Internal Load Balancers** not shown to reduce clutter

#### Assumptions

Our **Benchmarks/Load Tests** and **Profiling** show that we are read-heavy (100:1 with writes) and our database is suffering from poor performance from the high read requests.

#### Goals

- The following goals attempt to address the scaling issues with the **MySQL Database**
  - Based on the **Benchmarks/Load Tests** and **Profiling**, you might only need to implement one or two of these techniques
- Move the following data to a [**Memory Cache**](/#cache) such as Elasticache to reduce load and latency:
  - Frequently accessed content from **MySQL**
    - First, try to configure the **MySQL Database** cache to see if that is sufficient to relieve the bottleneck before implementing a **Memory Cache**
  - Session data from the **Web Servers**
    - The **Web Servers** become stateless, allowing for **Autoscaling**
  - Reading 1 MB sequentially from memory takes about 250 microseconds, while reading from SSD takes 4x and from disk takes 80x longer.<sup><a href="/#latency-numbers-every-programmer-should-know">1</a></sup>
- Add [**MySQL Read Replicas**](/#master-slave-replication) to reduce load on the write master
- Add more **Web Servers** and **Application Servers** to improve responsiveness

_Trade-offs, alternatives, and additional details:_

- See the linked content above for details

#### Add MySQL read replicas

- In addition to adding and scaling a **Memory Cache**, **MySQL Read Replicas** can also help relieve load on the **MySQL Write Master**
- Add logic to **Web Server** to separate out writes and reads
- Add **Load Balancers** in front of **MySQL Read Replicas** (not pictured to reduce clutter)
- Most services are read-heavy vs write-heavy

_Trade-offs, alternatives, and additional details:_

- See the [Relational database management system (RDBMS)](/#relational-database-management-system-rdbms) section

### Users++++

![Imgur](http://i.imgur.com/3X8nmdL.png)

#### Assumptions

Our **Benchmarks/Load Tests** and **Profiling** show that our traffic spikes during regular business hours in the U.S. and drop significantly when users leave the office. We think we can cut costs by automatically spinning up and down servers based on actual load. We're a small shop so we'd like to automate as much of the DevOps as possible for **Autoscaling** and for the general operations.

#### Goals

- Add **Autoscaling** to provision capacity as needed
  - Keep up with traffic spikes
  - Reduce costs by powering down unused instances
- Automate DevOps
  - Chef, Puppet, Ansible, etc
- Continue monitoring metrics to address bottlenecks
  - **Host level** - Review a single EC2 instance
  - **Aggregate level** - Review load balancer stats
  - **Log analysis** - CloudWatch, CloudTrail, Loggly, Splunk, Sumo
  - **External site performance** - Pingdom or New Relic
  - **Handle notifications and incidents** - PagerDuty
  - **Error Reporting** - Sentry

#### Add autoscaling

- Consider a managed service such as AWS **Autoscaling**
  - Create one group for each **Web Server** and one for each **Application Server** type, place each group in multiple availability zones
  - Set a min and max number of instances
  - Trigger to scale up and down through CloudWatch
    - Simple time of day metric for predictable loads or
    - Metrics over a time period:
      - CPU load
      - Latency
      - Network traffic
      - Custom metric
  - Disadvantages
    - Autoscaling can introduce complexity
    - It could take some time before a system appropriately scales up to meet increased demand, or to scale down when demand drops

### Users+++++

![Imgur](http://i.imgur.com/jj3A5N8.png)

**Note:** **Autoscaling** groups not shown to reduce clutter

#### Assumptions

As the service continues to grow towards the figures outlined in the constraints, we iteratively run **Benchmarks/Load Tests** and **Profiling** to uncover and address new bottlenecks.

#### Goals

We'll continue to address scaling issues due to the problem's constraints:

- If our **MySQL Database** starts to grow too large, we might consider only storing a limited time period of data in the database, while storing the rest in a data warehouse such as Redshift
  - A data warehouse such as Redshift can comfortably handle the constraint of 1 TB of new content per month
- With 40,000 average read requests per second, read traffic for popular content can be addressed by scaling the **Memory Cache**, which is also useful for handling the unevenly distributed traffic and traffic spikes
  - The **SQL Read Replicas** might have trouble handling the cache misses, we'll probably need to employ additional SQL scaling patterns
- 400 average writes per second (with presumably significantly higher peaks) might be tough for a single **SQL Write Master-Slave**, also pointing to a need for additional scaling techniques

SQL scaling patterns include:

- [Federation](/#federation)
- [Sharding](/#sharding)
- [Denormalization](/#denormalization)
- [SQL Tuning](/#sql-tuning)

To further address the high read and write requests, we should also consider moving appropriate data to a [**NoSQL Database**](/#nosql) such as DynamoDB.

We can further separate out our [**Application Servers**](/#application-layer) to allow for independent scaling. Batch processes or computations that do not need to be done in real-time can be done [**Asynchronously**](/#asynchronism) with **Queues** and **Workers**:

- For example, in a photo service, the photo upload and the thumbnail creation can be separated:
  - **Client** uploads photo
  - **Application Server** puts a job in a **Queue** such as SQS
  - The **Worker Service** on EC2 or Lambda pulls work off the **Queue** then:
    - Creates a thumbnail
    - Updates a **Database**
    - Stores the thumbnail in the **Object Store**

_Trade-offs, alternatives, and additional details:_

- See the linked content above for details

## Additional talking points

> Additional topics to dive into, depending on the problem scope and time remaining.

### SQL scaling patterns

- [Read replicas](/#master-slave-replication)
- [Federation](/#federation)
- [Sharding](/#sharding)
- [Denormalization](/#denormalization)
- [SQL Tuning](/#sql-tuning)

#### NoSQL

- [Key-value store](/pages/key-value-store)
- [Document store](/#document-store)
- [Wide column store](/#wide-column-store)
- [Graph database](/#graph-database)
- [SQL vs NoSQL](/pages/sql-or-nosql)

### Caching

- Where to cache
  - [Client caching](/#client-caching)
  - [CDN caching](/#cdn-caching)
  - [Web server caching](/#web-server-caching)
  - [Database caching](/#database-caching)
  - [Application caching](/#application-caching)
- What to cache
  - [Caching at the database query level](/#caching-at-the-database-query-level)
  - [Caching at the object level](/#caching-at-the-object-level)
- When to update the cache
  - [Cache-aside](/#cache-aside)
  - [Write-through](/#write-through)
  - [Write-behind (write-back)](/#write-behind-write-back)
  - [Refresh ahead](/#refresh-ahead)

### Asynchronism and microservices

- [Message queues](/#message-queues)
- [Task queues](/#task-queues)
- [Back pressure](/#back-pressure)
- [Microservices](/#microservices)

### Communications

- Discuss tradeoffs:
  - External communication with clients - [HTTP APIs following REST](/#representational-state-transfer-rest)
  - Internal communications - [RPC](/#remote-procedure-call-rpc)
- [Service discovery](/#service-discovery)

### Security

Refer to the [security section](/#security).

### Latency numbers

See [Latency numbers every programmer should know](/#latency-numbers-every-programmer-should-know).

### Ongoing

- Continue benchmarking and monitoring your system to address bottlenecks as they come up
- Scaling is an iterative process
