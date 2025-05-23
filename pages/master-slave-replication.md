---
title: Master-slave replication
---

The master serves reads and writes, replicating writes to one or more slaves,
which serve only reads. Slaves can also replicate to additional slaves in a
tree-like fashion. If the master goes offline, the system can continue to
operate in read-only mode until a slave is promoted to a master or a new master
is provisioned.

<p align="center">
  <img src="{{ "/images/C9ioGtn.png" | relative_url }}">
  <br/>
  <a href="http://www.slideshare.net/jboner/scalability-availability-stability-patterns">Source: Scalability, availability, stability, patterns</a>
</p>

### Disadvantage(s): master-slave replication {#disadvantages-master-slave-replication}

* Additional logic is needed to promote a slave to a master.
* See [Disadvantage(s): replication](/pages/replication#disadvantages-replication) for points
  related to **both** master-slave and master-master.

