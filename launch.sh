#!/bin/sh

# Create the domains directory
mkdir -p /domains/$DOMAIN

# Launch the directory monitor
# nohup node /app/index.js 1>/dev/null 2>&1
node /app/index.js

sleep 2
nodepid=`ps -ef | awk '/[n]ode/{print $2}'`

# Wait for 1/3 of a second to make sure the monitor is running.
sleep .3
echo "PID is $nodepid"
running=`kill -s 0 $nodepid`
echo "Running $running"
if [ "$running" ]; then
  echo "Directory monitor running."
el
  exit 1
fi

# Launch the letsencrypt client
letsencrypt $*
