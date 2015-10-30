#!/bin/bash

# Start MongoDB
/sbin/start-mongodb.sh

export CI=true
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# install dependencies and run default rake task
cd /var/simdata/openstudio
echo "I am running"
