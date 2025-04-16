#!/usr/bin/env bash
#================================================================================
# Title       : coverity_full.sh
# Author      : Didier Botella
# Version     : 1.2
# Date        : 2025-04-16
# Description : Make a full analysis
#================================================================================

# À ajouter après le source des variables
required_vars=(
    "COVERITY_URL"
    "COV_USER"
    "COVERITY_PASSPHRASE"
)

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: $var is not set"
        exit 1
    fi
done

# Check if required tools are installed
# Replace 'mvn' with the actual tool name
if ! command -v mvn &>/dev/null; then
    echo "Warning: mvn is not installed or not in PATH"
fi

# Check if required tools are installed
# Replace 'coverity' with the actual tool name
if ! command -v coverity &>/dev/null; then
    echo "Warning: coverity is not installed or not in PATH"
fi

export COV_IDIR=idir
export COV_PROJECT=commons-csv
export COV_STREAM=commons-csv

rm -rf "$COV_IDIR"
mvn clean

coverity scan \
    -o commit.connect.url="$COVERITY_URL" \
    -o commit.connect.project="$COV_PROJECT" \
    -o commit.connect.stream="$COV_STREAM" \
    --dir "$COV_IDIR" \
    -- mvn -Ddoclint=all --show-version --batch-mode --no-transfer-progress -Drat.skip=true install
