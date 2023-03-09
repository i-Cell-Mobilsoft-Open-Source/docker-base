#!/usr/bin/env bash

set -xe;

GROUP_PATH="${NEXUS_OBJECT_GROUP_ID//./\/}"
OBJECT_PATH="$GROUP_PATH/$NEXUS_OBJECT_ARTIFACT_ID/$NEXUS_OBJECT_VERSION/$NEXUS_OBJECT_ARTIFACT_ID-$NEXUS_OBJECT_VERSION.$NEXUS_OBJECT_EXTENSION"
OBJECT_PATH_SHA1="$GROUP_PATH/$NEXUS_OBJECT_ARTIFACT_ID/$NEXUS_OBJECT_VERSION/$NEXUS_OBJECT_ARTIFACT_ID-$NEXUS_OBJECT_VERSION.$NEXUS_OBJECT_EXTENSION.sha1"
#https://central.sonatype.org/search/example-urls/
MAVEN_SEARCH_API="https://search.maven.org/remotecontent?filepath="

curl -L -X GET $MAVEN_SEARCH_API$OBJECT_PATH --output $OUTPUT_FILE;
curl -L -X GET $MAVEN_SEARCH_API$OBJECT_PATH_SHA1 --output $OUTPUT_FILE.sha1;

# checksum ellenorzes
SHA1_ORIGINAL=$(cat $OUTPUT_FILE.sha1);
SHA1_FILE=$(sha1sum $OUTPUT_FILE | awk '{print $1}')
if [ "$SHA1_ORIGINAL" = "$SHA1_FILE" ]; then
    echo "Checksum OK"
else
    echo "Corrupted file!"
    exit 1
fi