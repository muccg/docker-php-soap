#!/bin/sh
#
# Script to build images
#

# break on error
set -e

REPO="muccg"
DATE=`date +%Y.%m.%d`

# build dirs, top level is php version
for phpdir in */
do
    phpver=`basename ${phpdir}`

    image="${REPO}/php-soap:${phpver}-apache"
    echo "################################################################### ${image}"
        
    ## warm up cache for CI
    docker pull ${image} || true

    ## build
    docker build --pull=true -t ${image}-${DATE} ${phpdir}
    docker build -t ${image} ${phpdir}

    ## for logging in CI
    docker inspect ${image}-${DATE}

    # push
    docker push ${image}-${DATE}
    docker push ${image}

done
