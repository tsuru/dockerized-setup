#!/bin/bash
mkdir -p /data/archive-server/archives
source /data/archive-server/archive-server
/usr/bin/archive-server $ARCHIVE_SERVER_OPTS
