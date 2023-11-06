#!/usr/bin/env bash
docker build -t system-design-primer .

docker run \
    -v .:/app \
    --workdir /app \
    -e JEKYLL_ENV=production \
    system-design-primer \
    bundle exec jekyll build -d ./docs -b /system-design-primer