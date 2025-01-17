---
title: Federation
layout: page
---

<p align="center">

<i><a href="{{ "/images/U3qV33e.png" | relative_url }}">Original image</a></i>

```mermaid!
graph LR
subgraph Federation
    direction LR
    subgraph forum[Forums DB]
        M1[M] --> S1[S]
        M1 -.-> R1[R]
    end
    subgraph user[Users DB]
        M2[M] --> S2[S]
        M2 -.-> R2[R]
    end
    subgraph products[Products DB]
        M3[M] --> S3[S]
        M3 -.-> R3[R]
    end
    forum -.- user -.- products
end
```

  <br/>
  <i><a href="https://www.youtube.com/watch?v=kKjm4ehYiMs">Source: Scaling up to your first 10 million users</a></i>  
</p>

Federation (or functional partitioning) splits up databases by function. For
example, instead of a single, monolithic database, you could have three
databases: **forums**, **users**, and **products**, resulting in less read and
write traffic to each database and therefore less replication lag. Smaller
databases result in more data that can fit in memory, which in turn results in
more cache hits due to improved cache locality. With no single central master
serializing writes you can write in parallel, increasing throughput.

### Disadvantage(s): federation {#disadvantages-federation}

- Federation is not effective if your schema requires huge functions or tables.
- You'll need to update your application logic to determine which database to read and write.
- Joining data from two databases is more complex with a [server link](http://stackoverflow.com/questions/5145637/querying-data-by-joining-two-tables-in-two-database-on-different-servers).
- Federation adds more hardware and additional complexity.

### Source(s) and further reading: federation {#sources-and-further-reading-federation}

- [Scaling up to your first 10 million users](https://www.youtube.com/watch?v=kKjm4ehYiMs)
