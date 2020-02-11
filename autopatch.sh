#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
MOUNT_POINT=~/Desktop/navicat-15-premium-en
APP_POINT=$1
                                                                                                                              
set -e
set -o pipefail
                                                                                                                                                                               
function fail {
    printf 'fail => %s' "$1" >&2
    exit "${2-1}"                                                                                                                                                                             
}

function checkMounted {
    if [[ ! -d $MOUNT_POINT ]]; then 
        mkdir -p $MOUNT_POINT
    else
        sudo umount $MOUNT_POINT || echo 'ok'
    fi

    sudo mount -o loop $APP_POINT $MOUNT_POINT
    cp -R $MOUNT_POINT ~/Desktop/navicat-15-patched
}

checkMounted
# patched
$SCRIPT_PATH/bin/navicat-patcher ~/Desktop/navicat-15-patched
# make patched image
$SCRIPT_PATH/appimagetool-x86_64.AppImage ~/Desktop/navicat-15-patched ~/Desktop/navicat15-premium-en.AppImage
# run patched image
~/Desktop/navicat15-premium-en.AppImage &
# start activate process
$SCRIPT_PATH/bin/navicat-keygen --text ./RegPrivateKey.pem
