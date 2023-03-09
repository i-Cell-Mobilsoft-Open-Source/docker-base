#!/usr/bin/env bash

set -xe;

SONATYPE_URL="https://repository.sonatype.org";
SONATYPE_API="service/local/artifact/maven/content?r=central-proxy&g=$NEXUS_OBJECT_GROUP_ID&a=$NEXUS_OBJECT_ARTIFACT_ID&e=$NEXUS_OBJECT_EXTENSION&v=$NEXUS_OBJECT_VERSION";
SONATYPE_API_SHA1="service/local/artifact/maven/content?r=central-proxy&g=$NEXUS_OBJECT_GROUP_ID&a=$NEXUS_OBJECT_ARTIFACT_ID&e=$NEXUS_OBJECT_EXTENSION.sha1&v=$NEXUS_OBJECT_VERSION";
SONATYPE_DOWNLOAD=$SONATYPE_URL$SONATYPE_API

curl -L -X GET $SONATYPE_URL/$SONATYPE_API --output $OUTPUT_FILE;
curl -L -X GET $SONATYPE_URL/$SONATYPE_API_SHA1 --output $OUTPUT_FILE.sha1;

# checksum ellenorzes
SHA1_ORIGINAL=$(cat $OUTPUT_FILE.sha1);
SHA1_FILE=$(sha1sum $OUTPUT_FILE | awk '{print $1}')
if [ "$SHA1_ORIGINAL" = "$SHA1_FILE" ]; then
    echo "Checksum OK"
else
    echo "Corrupted file!"
    exit 1
fi