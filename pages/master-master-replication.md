---
title: Master-master replication
---

Both masters serve reads and writes and coordinate with each other on writes.
If either master goes down, the system can continue to operate with both reads
and writes.

<p align="center">
  <img src="{{ "/images/krAHLGg.png" | relative_url }}">
  <br/>
  <i><a href="http://www.slideshare.net/jboner/scalability-availability-stability-patterns">Source: Scalability, availability, stability, patterns</a></i>
</p>

### Disadvantage(s): master-master replication {#disadvantages-master-master-replication}

* You'll need a load balancer or you'll need to make changes to your
  application logic to determine where to write.
* Most master-master systems are either loosely consistent (violating ACID) or
  have increased write latency due to synchronization.
* Conflict resolution comes more into play as more write nodes are added and as
  latency increases.
* See [Disadvantage(s): replication](/pages/replication#disadvantages-replication) for points
  related to **both** master-slave and master-master.
