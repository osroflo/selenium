#!/bin/sh
set -x

if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then  
    addgroup -g ${GROUP_ID} deploy
    adduser -G deploy -u ${USER_ID} -s /bin/sh -D deploy
    echo "deploy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi
