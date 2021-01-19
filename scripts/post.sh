#!/bin/sh

eval "$(cat .env <(echo) <(declare -x))"

custom_path=[custom_path]

docker-compose run --rm blogsync post --title=draft --draft --custom-path=${custom_path} ${DOMAIN} < draft.md
