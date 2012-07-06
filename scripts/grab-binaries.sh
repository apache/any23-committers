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

    if [ -z "${5}" ]; then
        CLASSIFIED_VERSION=${VERSION}
    else
        CLASSIFIED_VERSION=${VERSION}-${5}
    fi

    wget --no-check-certificate ${REPO_BASE}-${REPO_ID}/$(echo $GROUP_ID | sed 's/\./\//g')/${ARTIFACT_ID}/${VERSION}/${ARTIFACT_ID}-${CLASSIFIED_VERSION}.${PACKAGING}
}

function grabAll
{
    GROUP_ID=${1}
    ARTIFACT_ID=${2}
    VERSION=${3}
    CLASSIFIER=${4}

    for type in zip tar.gz; do
        grab ${GROUP_ID} ${ARTIFACT_ID} ${VERSION} ${type} ${CLASSIFIER}

        for ext in asc md5 sha1; do
            grab ${GROUP_ID} ${ARTIFACT_ID} ${VERSION} ${type}.${ext} ${CLASSIFIER}
        done
    done
}

cd sources
grabAll org.apache.any23 apache-any23 ${ANY23_VERSION} src

cd ../binaries
grabAll org.apache.any23 apache-any23-core ${ANY23_VERSION}
grabAll org.apache.any23.plugins apache-any23-basic-crawler ${CRAWLER_VERSION}
grabAll org.apache.any23.plugins apache-any23-html-scraper ${HTML_SCRAPER_VERSION}
grabAll org.apache.any23.plugins apache-any23-office-scraper ${OFFICE_SCRAPER_VERSION}

for classifier in with-deps without-deps server-embedded; do
    grabAll org.apache.any23 apache-any23-service ${ANY23_VERSION} ${classifier}
done
