#!/bin/bash

set -eux -o pipefail

SHARE_DIR=share
URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City-CSV&license_key=${MM_LICENSE_KEY}&suffix=zip"
ARCHIVE_NAME=GeoLite2-City-CSV.zip
SHA_SUFFIX=".sha256"

mkdir -p $SHARE_DIR

pushd $SHARE_DIR || exit 1

FILE_OR_TIME=$ARCHIVE_NAME
SHA_FILE_OR_TIME="${ARCHIVE_NAME}${SHA_SUFFIX}"

# -z expects a file name or a timestamp. Let's set a timestamp far in the past,
# so that we don't get a warning if the file does not already exist.
if [[ ! -e "$ARCHIVE_NAME" ]];then
    FILE_OR_TIME="1999-12-31T23:59:59"
    SHA_FILE_OR_TIME=$FILE_OR_TIME
fi

curl --location -z "$FILE_OR_TIME" -v "${URL}" -o "$ARCHIVE_NAME"
curl --location -z "$SHA_FILE_OR_TIME" -v "${URL}${SHA_SUFFIX}" -o "${ARCHIVE_NAME}${SHA_SUFFIX}"

sha256sum GeoLite2-City-CSV.zip > downloaded.sha256

# Fix up filename in downloaded SHA so that the check doesn't choke on it
perl -pi -e 's/_\d+//g' GeoLite2-City-CSV.zip.sha256
sha256sum --check --status downloaded.sha256 GeoLite2-City-CSV.zip.sha256

DBS=dbs
mkdir -p "$DBS"

TMPDIR=$(mktemp -d /tmp/mmcsv.XXXXXXXXXX) || exit 1

unzip "$ARCHIVE_NAME" -d "$TMPDIR"
find "$TMPDIR" -type f -name '*Blocks*' -print0 | xargs -0 -I '{}' cp '{}' "${DBS}/"
find "$TMPDIR" -type f -name 'GeoLite2-City-Locations-en.csv' -print0 | xargs -0 -I '{}' cp '{}' "${DBS}/"

exit 0
