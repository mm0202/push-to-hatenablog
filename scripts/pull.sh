#!/bin/sh

eval "$(cat .env <(echo) <(declare -x))"

docker-compose run --rm blogsync pull $DOMAIN
