---
layout: post
title:  Scaling Methods
date:   2023-11-30 12:01:00 +0700
categories: scaling
---

```mermaid!
---
title: Scaling Web Apps
---
graph TD
    Request --> Web --> Application --> Database --> Response
    subgraph Web
        Cache1[Cache]
        CDN
        LoadBlancing
    end
    subgraph Application
        Cache2[Cache]
        AsyncTasks
    end
    subgraph Database
        Cache3[Cache]
        Sharding
        Federation
        WriteMaster
        ObjectStore
        NoSQL
    end
```
