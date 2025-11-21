#!/usr/bin/env bash

set -e;

echo "NEXUS_USER=$NEXUS_USER"
echo "NEXUS_OBJECT_GROUP_ID=$NEXUS_OBJECT_GROUP_ID"
echo "NEXUS_OBJECT_ARTIFACT_ID=$NEXUS_OBJECT_ARTIFACT_ID"
echo "NEXUS_OBJECT_VERSION=$NEXUS_OBJECT_VERSION"
echo "NEXUS_OBJECT_CLASSIFIER=$NEXUS_OBJECT_CLASSIFIER"
echo "NEXUS_REPOSITORY_TYPE=$NEXUS_REPOSITORY_TYPE"

if [ -z "$NEXUS_OBJECT_CLASSIFIER" ]; then
    # we are looking for empty classifiers by default
    PATH_PARAM_CLASSIFIER=""
    QUERY_PARAM_CLASSIFIER=""
else
    PATH_PARAM_CLASSIFIER="-$NEXUS_OBJECT_CLASSIFIER"
    QUERY_PARAM_CLASSIFIER="&c=$NEXUS_OBJECT_CLASSIFIER"
fi

NEXUS_OBJECT_EXTENSION=${NEXUS_OBJECT_EXTENSION:-jar}
echo "NEXUS_OBJECT_EXTENSION=$NEXUS_OBJECT_EXTENSION"
NEXUS_DOWNLOAD_OUTPUT_FILE_NAME=${NEXUS_DOWNLOAD_OUTPUT_FILE_NAME:-"$NEXUS_OBJECT_ARTIFACT_ID-$NEXUS_OBJECT_VERSION$PATH_PARAM_CLASSIFIER.$NEXUS_OBJECT_EXTENSION"}
NEXUS_DOWNLOAD_OUTPUT_FILE_NAME_SHA1=${NEXUS_DOWNLOAD_OUTPUT_FILE_NAME_SHA1:-"$NEXUS_DOWNLOAD_OUTPUT_FILE_NAME.sha1"}
echo "NEXUS_DOWNLOAD_OUTPUT_FILE_NAME=$NEXUS_DOWNLOAD_OUTPUT_FILE_NAME"
echo "NEXUS_DOWNLOAD_OUTPUT_FILE_NAME_SHA1=$NEXUS_DOWNLOAD_OUTPUT_FILE_NAME_SHA1"

if [ "$NEXUS_REPOSITORY_TYPE" = "central" ]; then
  NEXUS_OBJECT_GROUP_ID_SLASHED=${NEXUS_OBJECT_GROUP_ID//./\/}
  # New central repository handling
  if [[ "$NEXUS_OBJECT_VERSION" == *"-SNAPSHOT"* ]]; then
    # Snapshot version handling
    echo "Snapshot version detected: $NEXUS_OBJECT_VERSION"
    SONATYPE_URL=https://central.sonatype.com/repository/maven-snapshots
    echo "SONATYPE_URL=$SONATYPE_URL"

    # get actual snapshot version from maven-metadata.xml
    MAVEN_METADATA_URL="$SONATYPE_URL/$NEXUS_OBJECT_GROUP_ID_SLASHED/$NEXUS_OBJECT_ARTIFACT_ID/$NEXUS_OBJECT_VERSION/maven-metadata.xml"
    echo "MAVEN_METADATA_URL=$MAVEN_METADATA_URL"
    METADATA_CONTENT=$(curl -s "$MAVEN_METADATA_URL")

    # Try exact match (extension + optional classifier)
    SNAPSHOT_VALUE=$(echo "$METADATA_CONTENT" | awk -v ext="$NEXUS_OBJECT_EXTENSION" -v cls="$NEXUS_OBJECT_CLASSIFIER" '
    /<snapshotVersion>/ {inside=1; e=""; c=""; v=""}
    /<\/snapshotVersion>/ {
      if(inside && e==ext && ((cls=="" && c=="") || c==cls)) {print v; exit}
      inside=0
    }
    inside && /<extension>/ {gsub(/.*<extension>|<\/extension>.*/,""); e=$0}
    inside && /<classifier>/ {gsub(/.*<classifier>|<\/classifier>.*/,""); c=$0}
    inside && /<value>/ {gsub(/.*<value>|<\/value>.*/,""); v=$0}
    ')

    # Fallback: pick first pom without classifier
    if [ -z "$SNAPSHOT_VALUE" ]; then
      SNAPSHOT_VALUE=$(echo "$METADATA_CONTENT" | awk '
      /<snapshotVersion>/ {inside=1; e=""; c=""; v=""}
    /<\/snapshotVersion>/ {
      if(inside && e=="pom" && c=="") {print v; exit}
      inside=0
    }
    inside && /<extension>/ {gsub(/.*<extension>|<\/extension>.*/,""); e=$0}
    inside && /<classifier>/ {gsub(/.*<classifier>|<\/classifier>.*/,""); c=$0}
    inside && /<value>/ {gsub(/.*<value>|<\/value>.*/,""); v=$0}
    ')
    fi

    echo "SNAPSHOT_VALUE=$SNAPSHOT_VALUE"

    if [ -z "$SNAPSHOT_VALUE" ]; then
      echo "Could not determine snapshot value" >&2
      exit 1
    fi

    # Build artifact file name (snapshot replaces version; classifier comes last if present)
    if [ -z "$NEXUS_OBJECT_CLASSIFIER" ]; then
      SNAPSHOT_FILE_NAME="$NEXUS_OBJECT_ARTIFACT_ID-$SNAPSHOT_VALUE.$NEXUS_OBJECT_EXTENSION"
    else
      SNAPSHOT_FILE_NAME="$NEXUS_OBJECT_ARTIFACT_ID-$SNAPSHOT_VALUE-$NEXUS_OBJECT_CLASSIFIER.$NEXUS_OBJECT_EXTENSION"
    fi

    # create download url:
    # e.g.: https://central.sonatype.com/repository/maven-snapshots/hu/icellmobilsoft/dookug/dookug-document-service/2.1.0-SNAPSHOT/dookug-document-service-2.1.0-20251119.090549-1.war
    SONATYPE_DOWNLOAD="$SONATYPE_URL/$NEXUS_OBJECT_GROUP_ID_SLASHED/$NEXUS_OBJECT_ARTIFACT_ID/$NEXUS_OBJECT_VERSION/$SNAPSHOT_FILE_NAME"
    echo "SONATYPE_DOWNLOAD=$SONATYPE_DOWNLOAD"
    SONATYPE_DOWNLOAD_SHA1="$SONATYPE_DOWNLOAD.sha1"
    echo "SONATYPE_DOWNLOAD_SHA1=$SONATYPE_DOWNLOAD_SHA1"
  else
    # Release version handling
    echo "Release version detected: $NEXUS_OBJECT_VERSION"
    SONATYPE_URL=https://repo1.maven.org/maven2
    echo "SONATYPE_URL=$SONATYPE_URL"
    SONATYPE_DOWNLOAD="$SONATYPE_URL/$NEXUS_OBJECT_GROUP_ID_SLASHED/$NEXUS_OBJECT_ARTIFACT_ID/$NEXUS_OBJECT_VERSION/$NEXUS_OBJECT_ARTIFACT_ID-$NEXUS_OBJECT_VERSION$PATH_PARAM_CLASSIFIER.$NEXUS_OBJECT_EXTENSION"
    echo "SONATYPE_DOWNLOAD=$SONATYPE_DOWNLOAD"
    SONATYPE_DOWNLOAD_SHA1="$SONATYPE_DOWNLOAD.sha1"
    echo "SONATYPE_DOWNLOAD_SHA1=$SONATYPE_DOWNLOAD_SHA1"
  fi
else
  # Old sonatype repository handling
  SONATYPE_REPOSITORY=${SONATYPE_REPOSITORY:-public}
  echo "SONATYPE_REPOSITORY=$SONATYPE_REPOSITORY"
  SONATYPE_URL=${SONATYPE_URL:-https://oss.sonatype.org}
  echo "SONATYPE_URL=$SONATYPE_URL"
  SONATYPE_API="service/local/artifact/maven/content?r=$SONATYPE_REPOSITORY&g=$NEXUS_OBJECT_GROUP_ID&a=$NEXUS_OBJECT_ARTIFACT_ID&e=$NEXUS_OBJECT_EXTENSION$QUERY_PARAM_CLASSIFIER&v=$NEXUS_OBJECT_VERSION";
  echo "SONATYPE_API=$SONATYPE_API"
  SONATYPE_API_SHA1="service/local/artifact/maven/content?r=$SONATYPE_REPOSITORY&g=$NEXUS_OBJECT_GROUP_ID&a=$NEXUS_OBJECT_ARTIFACT_ID$QUERY_PARAM_CLASSIFIER&e=$NEXUS_OBJECT_EXTENSION.sha1&v=$NEXUS_OBJECT_VERSION";
  echo "SONATYPE_API_SHA1=$SONATYPE_API_SHA1"
  SONATYPE_DOWNLOAD=$SONATYPE_URL/$SONATYPE_API
  SONATYPE_DOWNLOAD_SHA1=$SONATYPE_URL/$SONATYPE_API_SHA1
fi

# NEXUS_USER null check
if [ ! -z "$NEXUS_USER" ]; then
    # we activate it (if we need)
    CURL_USER="-u $NEXUS_USER:$NEXUS_PASSWORD "
fi

if [ -n "$DEBUG" ]; then
  set -x
fi

curl -L $CURL_USER -X GET "$SONATYPE_DOWNLOAD" --output $NEXUS_DOWNLOAD_OUTPUT_FILE_NAME;
curl -L $CURL_USER -X GET "$SONATYPE_DOWNLOAD_SHA1" --output $NEXUS_DOWNLOAD_OUTPUT_FILE_NAME_SHA1;

FILE_SIZE=$(stat -c%s "$NEXUS_DOWNLOAD_OUTPUT_FILE_NAME")
SHA1_FILE_SIZE=$(stat -c%s "$NEXUS_DOWNLOAD_OUTPUT_FILE_NAME_SHA1")
echo "$PWD/$NEXUS_DOWNLOAD_OUTPUT_FILE_NAME file downloaded, size: $FILE_SIZE bytes."
echo "$PWD/$NEXUS_DOWNLOAD_OUTPUT_FILE_NAME_SHA1 file downloaded, size: $SHA1_FILE_SIZE bytes."

# checksum 
SHA1_ORIGINAL=$(cat $DOWNLOAD_DIR/$NEXUS_DOWNLOAD_OUTPUT_FILE_NAME_SHA1);
SHA1_FILE=$(sha1sum $DOWNLOAD_DIR/$NEXUS_DOWNLOAD_OUTPUT_FILE_NAME | awk '{print $1}')
if [ "$SHA1_ORIGINAL" = "$SHA1_FILE" ]; then
    echo "Checksum OK"
else
    echo "Corrupted file!"
    if [ -n "$DEBUG" ]; then
      set +x
    fi
    exit 1
fi

if [ -n "$DEBUG" ]; then
  set +x
fi
