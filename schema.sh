#!/bin/bash

set -eux

# create tables
psql -d mm_database -U root -a --file=/tmp/schema.sql

SHARE=/share/dbs
pushd $SHARE || exit 1
# PRODUCTS=("GeoIP2-Anonymous-IP" "GeoIP2-Enterprise" "GeoLite2-City")
PRODUCTS=("GeoLite2-City")

for PRODUCT in "${PRODUCTS[@]}"; do
    echo "🎸 starting product $PRODUCT"
    FILE_PREFIX="${SHARE}/${PRODUCT}/${PRODUCT}"

    psql -d mm_database -U root -a -v file="${FILE_PREFIX}-Blocks-IPv4.csv" -f /tmp/copy_network.sql
    psql -d mm_database -U root -a -v file="${FILE_PREFIX}-Blocks-IPv6.csv" -f /tmp/copy_network.sql

    LOCATIONS_FILE="${FILE_PREFIX}-Locations-en.csv"
    if [[ -f $LOCATIONS_FILE ]]; then
        psql -d mm_database -U root -a -v file="$LOCATIONS_FILE" -f /tmp/copy_location.sql
    fi

done
