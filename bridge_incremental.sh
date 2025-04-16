#!/usr/bin/env bash
#================================================================================
# Title       : bridge_incremental.sh
# Author      : Didier Botella
# Version     : 1.2
# Date        : 2025-04-16
# Description : Make an incremental  analysis with bridge
#================================================================================

COV_ANALYSIS_PATH=/Applications/cov-analysis-macos-arm-2024.12.0

# À ajouter après le source des variables
required_vars=(
    "COVERITY_URL"
    "COV_USER"
    "COVERITY_PASSPHRASE"
    "COV_ANALYSIS_PATH"
)

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: $var is not set"
        exit 1
    fi
done

export BRIDGE_PATH=bridge

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    BRIDGE_PATH=bridge-cli-bundle-linux64
    [[ -f "$BRIDGE_PATH".zip ]] || wget "https://repo.blackduck.com/bds-integrations-release/com/blackduck/integration/bridge/binaries/bridge-cli-bundle/latest/bridge-cli-bundle-linux64.zip"
    [[ -d "$BRIDGE_PATH" ]] || unzip ./"$BRIDGE_PATH".zip
    export PATH=$PATH:$BRIDGE_PATH
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ "$(uname -m)" == "arm64" ]]; then
        BRIDGE_PATH=bridge-cli-bundle-macos_arm
        [[ -f "$BRIDGE_PATH".zip ]] || wget "https://repo.blackduck.com/bds-integrations-release/com/blackduck/integration/bridge/binaries/bridge-cli-bundle/latest/bridge-cli-bundle-macos_arm.zip"
        [[ -d "$BRIDGE_PATH" ]] || unzip ./"$BRIDGE_PATH".zip
        export PATH=$PATH:$BRIDGE_PATH
    else
        BRIDGE_PATH=bridge-cli-bundle-macos
        [[ -f "$BRIDGE_PATH".zip ]] || wget "https://repo.blackduck.com/bds-integrations-release/com/blackduck/integration/bridge/binaries/bridge-cli-bundle/latest/bridge-cli-bundle-macosx.zip"
        [[ -d "$BRIDGE_PATH" ]] || unzip ./"$BRIDGE_PATH".zip
        export PATH=$PATH:$BRIDGE_PATH
    fi
fi

export BRIDGE_COVERITY_CONNECT_USER_NAME="$COV_USER"
export BRIDGE_COVERITY_CONNECT_USER_PASSWORD="$COVERITY_PASSPHRASE"

export COVERITY_PROJECT=commons-csv
export COVERITY_STREAM=commons-csv-bridge
export COVERITY_VIEW_NAME="(Global) Non Legacy Issues"

bridge-cli --stage connect \
    coverity.connect.url="$COVERITY_URL" \
    coverity.connect.project.name="$COVERITY_PROJECT" \
    coverity.connect.stream.name="$COVERITY_STREAM" \
    coverity.connect.policy.view="$COVERITY_VIEW_NAME" \
    coverity.install.directory="$COV_ANALYSIS_PATH" \
    coverity.automation.prcomment="true" \
    coverity.local=true
