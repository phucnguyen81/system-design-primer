---
title: Replication
---

## Master-slave and master-master {#master-slave-and-master-master}

This topic is further discussed in the [Database](/#database) section:

- [Master-slave replication](/pages/master-slave-replication)
- [Master-master replication](/pages/master-master-replication)

## Disadvantage(s): replication {#disadvantages-replication}

- There is a potential for loss of data if the master fails before any newly
  written data can be replicated to other nodes.
- Writes are replayed to the read replicas. If there are a lot of writes, the
  read replicas can get bogged down with replaying writes and can't do as many
  reads.
- The more read slaves, the more you have to replicate, which leads to greater
  replication lag.
- On some systems, writing to the master can spawn multiple threads to write in
  parallel, whereas read replicas only support writing sequentially with a
  single thread.
- Replication adds more hardware and additional complexity.

## Source(s) and further reading: replication {#sources-and-further-reading-replication}

- [Scalability, availability, stability, patterns](http://www.slideshare.net/jboner/scalability-availability-stability-patterns/)
- [Multi-master replication](https://en.wikipedia.org/wiki/Multi-master_replication)
