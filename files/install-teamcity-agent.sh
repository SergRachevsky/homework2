#!/usr/bin/bash

docker pull jetbrains/teamcity-agent

docker run -e SERVER_URL="radogor.teamcity.com" \
    -v /opt/teamcity_agent:/data/teamcity_agent/conf  \
    jetbrains/teamcity-agent
