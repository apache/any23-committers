#!/bin/bash

#  Licensed to the Apache Software Foundation (ASF) under one or more
#  contributor license agreements.  See the NOTICE file distributed with
#  this work for additional information regarding copyright ownership.
#  The ASF licenses this file to You under the Apache License, Version 2.0
#  (the "License"); you may not use this file except in compliance with
#  the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

export REPO_BASE=https://repository.apache.org/content/repositories/orgapacheany23

export REPO_ID=${1}
export ANY23_VERSION=${2}
export CRAWLER_VERSION=${3}
export HTML_SCRAPER_VERSION=${4}
export OFFICE_SCRAPER_VERSION=${5}

function grab
{
    GROUP_ID=${1}
    ARTIFACT_ID=${2}
    VERSION=${3}
    PACKAGING=${4}
    wget --no-check-certificate ${REPO_BASE}-${REPO_ID}/$(echo $GROUP_ID | sed 's/\./\//g')/${ARTIFACT_ID}/${VERSION}/${ARTIFACT_ID}-${VERSION}.${PACKAGING}
}

function grabAll
{
    for type in zip tar.gz; do
        grab ${1} ${2} ${3} ${type}

        for ext in asc md5 sha1; do
            grab ${1} ${2} ${3} ${type}.${ext}
        done
    done
}

cd sources
grabAll org.apache.any23 any23-sources-dist ${ANY23_VERSION}

cd ../binaries
grabAll org.apache.any23 any23-core ${ANY23_VERSION}
grabAll org.apache.any23.plugins any23-core ${CRAWLER_VERSION}
grabAll org.apache.any23.plugins any23-core ${HTML_SCRAPER_VERSION}
grabAll org.apache.any23.plugins any23-core ${OFFICE_SCRAPER_VERSION}
grabAll org.apache.any23 any23-service ${ANY23_VERSION}
