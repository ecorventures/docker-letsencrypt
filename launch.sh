#!/bin/sh

# Create the domains directory
mkdir -p /domains/$DOMAIN

# Launch the directory monitor
nohup node /app/index.js &

sleep .2
nodepid=`ps -ef | awk '/[n]ode/{print $1}'`

# Wait for 1/3 of a second to make sure the monitor is running.
if [ $nodepid ]; then
  echo "Directory monitor running as PID $nodepid."
else
  echo "blah"
  exit 1
fi

echo "1"
echo $*
echo "2"

# Launch the letsencrypt client
/letsencrypt/venv/bin/letsencrypt $*
