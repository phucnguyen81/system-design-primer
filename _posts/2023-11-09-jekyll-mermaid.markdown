---
layout: post
title:  "Jekyll Mermaid"
date:   2023-11-09 08:00:00 +0700
categories: jekyll mermaid
---
## Use Mermaid diagrams

Install the [jekyll-spaceship](https://github.com/jeffreytse/jekyll-spaceship),
plugin, which enables not just mermaid but also math, table, uml,...

Add the plugin to `Gemfile`:
```ruby
group :jekyll_plugins do
  gem "jekyll-spaceship", "~> 0.10.2"
end
```

Add the plugin to `_config.yml`:
```yaml
plugins:
  - jekyll-spaceship  
```

## Examples of Mermaid diagrams

### Mermaid piechart diagram

```mermaid!
pie title Pets adopted by volunteers
  "Dogs" : 386
  "Cats" : 85
  "Rats" : 35
```

### Mermaid flowchart diagram

```mermaid!
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```

