#!/bin/bash

set -eux

psql -h localhost -U root -d mm_database
