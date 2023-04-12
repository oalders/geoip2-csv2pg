#!/bin/bash

set -eux

PRODUCT=GeoLite2-City
FILE_PREFIX="/share/dbs/${PRODUCT}/${PRODUCT}"

# create tables
psql -d mm_database -U root -a --file=/tmp/schema.sql

psql -d mm_database -U root -a -v file="${FILE_PREFIX}-Blocks-IPv4.csv" -f /tmp/copy_network.sql
psql -d mm_database -U root -a -v file="${FILE_PREFIX}-Locations-en.csv" -f /tmp/copy_location.sql

exit 0
