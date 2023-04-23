#!/bin/bash

set -eux -o pipefail

DATABASES=("GeoIP2-Anonymous-IP" "GeoLite2-City" "GeoIP2-Enterprise")
SHARE_DIR=/root/share
mkdir -p $SHARE_DIR
pushd $SHARE_DIR || exit 1
find .

for I in "${!DATABASES[@]}"; do
    PRODUCT=${DATABASES[$I]}
    URL="https://download.maxmind.com/app/geoip_download?edition_id=${PRODUCT}-CSV&license_key=${MM_LICENSE_KEY}&suffix=zip"
    ARCHIVE_NAME="${PRODUCT}-CSV.zip"
    SHA_SUFFIX=".sha256"

    FILE_OR_TIME=$ARCHIVE_NAME
    SHA_FILE_OR_TIME="${ARCHIVE_NAME}${SHA_SUFFIX}"

    # -z expects a file name or a timestamp. Let's set a timestamp far in the past,
    # so that we don't get a warning if the file does not already exist.
    if [[ ! -e "$ARCHIVE_NAME" ]]; then
        FILE_OR_TIME="1999-12-31T23:59:59"
        SHA_FILE_OR_TIME=$FILE_OR_TIME
    fi

    curl --location -z "$FILE_OR_TIME" -v "${URL}" -o "$ARCHIVE_NAME"
    curl --location -z "$SHA_FILE_OR_TIME" -v "${URL}${SHA_SUFFIX}" -o "${ARCHIVE_NAME}${SHA_SUFFIX}"

    SHA_FILE="${ARCHIVE_NAME}.downloaded.sha256"
    sha256sum "$ARCHIVE_NAME" >"$SHA_FILE"

    # Fix up filename in downloaded SHA so that the check doesn't choke on it
    perl -pi -e 's/_\d+//g' "${ARCHIVE_NAME}.sha256"
    sha256sum -c -s "$SHA_FILE" "${ARCHIVE_NAME}.sha256"

    DBS="dbs/${PRODUCT}"
    mkdir -p "$DBS"

    TMPDIR=$(mktemp -d /tmp/mmcsv.XXXXXXXXXX) || exit 1

    unzip "$ARCHIVE_NAME" -d "$TMPDIR"
    find "$TMPDIR" -type f -name '*Blocks*' -print0 | xargs -0 -I '{}' cp '{}' "${DBS}/"
    find "$TMPDIR" -type f -name "${PRODUCT}-Locations-en.csv" -print0 | xargs -0 -I '{}' cp '{}' "${DBS}/"
    find "$TMPDIR" -type f -name "${PRODUCT}-ISP.csv" -print0 | xargs -0 -I '{}' cp '{}' "${DBS}/"
done

exit 0
