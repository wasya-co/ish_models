#!/bin/bash


curl --user art-donor:$passwd -X POST \
  https://piousbox.com/wp-json/wp/v2/posts \
  -H 'Content-Type: application/json' \
  -d '{ "title": "My Title 10",
    "content": "My Content", "status": "publish", "categories": 203, "date": "2023-01-26T00:00:00" }'
