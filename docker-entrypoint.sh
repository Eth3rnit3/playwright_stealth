#!/bin/bash

if [ -f /tmp/.X99-lock ]; then 
  rm -f /tmp/.X99-lock
fi

if ! pgrep -x "Xvfb" > /dev/null; then 
  Xvfb :99 -screen 0 1920x1080x24 &
fi

npx http-server /app/tests/whereIClick -p 8001 -c-1 &

exec "$@"
