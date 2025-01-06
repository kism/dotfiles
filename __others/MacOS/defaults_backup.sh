#!/usr/bin/env bash

source defaults_list.env

echo "Defaults: "
for i in "${DEFAULTS_TO_MANAGE[@]}"
do
  echo "$i"
done

echo "Backing up defaults..."
for i in "${DEFAULTS_TO_MANAGE[@]}"
do
  echo "Backing up $i"
  defaults read $i > "defaults/$i.json"
done

