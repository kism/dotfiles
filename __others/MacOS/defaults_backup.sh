#!/usr/bin/env bash

source defaults_list.env

echo "Defaults: "
for i in "${DEFAULTS_TO_MANAGE[@]}"
do
  echo "$i"
done

echo

echo "Restoring defaults..."
for i in "${DEFAULTS_TO_MANAGE[@]}"
do
  echo "Restoring $i"
  defaults read "$i" > "defaults/$i.json"
done

