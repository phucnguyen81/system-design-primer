---
title: Sharding
layout: page
---

<p align="center">
  <i><a href="{{ "/images/wU8x5Id.png" | relative_url }}">Original image</a></i>
  <br/>

```mermaid!
graph TD
  App:::app -->|User: Adam| LB[Load Balancer]:::balancer
  LB --> A[(User A-C)]:::db
  LB -.- B[(User D-F)]:::db
  LB -.- C[(User G-I)]:::db
  LB -.- D[(User X-Y)]:::db
```

  <br/>
  <i><a href="http://www.slideshare.net/jboner/scalability-availability-stability-patterns/">Source: Scalability, availability, stability, patterns</a></i>
</p>

Sharding distributes data across different databases such that each database
can only manage a subset of the data. Taking a users database as an example,
as the number of users increases, more shards are added to the cluster.

Similar to the advantages of [federation](/pages/federation.md), sharding
results in less read and write traffic, less replication, and more cache hits.
Index size is also reduced, which generally improves performance with faster
queries. If one shard goes down, the other shards are still operational,
although you'll want to add some form of replication to avoid data loss. Like
federation, there is no single central master serializing writes, allowing you
to write in parallel with increased throughput.

Common ways to shard a table of users is either through the user's last name
initial or the user's geographic location.

### Disadvantage(s): sharding {#disadvantages-sharding}

* You'll need to update your application logic to work with shards, which could
  result in complex SQL queries.
* Data distribution can become lopsided in a shard.  For example, a set of
  power users on a shard could result in increased load to that shard compared
  to others.
    * Rebalancing adds additional complexity.  A sharding function based on
      [consistent hashing](http://www.paperplanes.de/2011/12/9/the-magic-of-consistent-hashing.html)
      can reduce the amount of transferred data.
* Joining data from multiple shards is more complex.
* Sharding adds more hardware and additional complexity.

### Source(s) and further reading: sharding {#sources-and-further-reading-sharding}

* [The coming of the shard](http://highscalability.com/blog/2009/8/6/an-unorthodox-approach-to-database-design-the-coming-of-the.html)
* [Shard database architecture](https://en.wikipedia.org/wiki/Shard_(database_architecture))
* [Consistent hashing](http://www.paperplanes.de/2011/12/9/the-magic-of-consistent-hashing.html)

