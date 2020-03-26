#!/bin/bash

bash -c "exec -a vnc_service ./vnc_service.sh &"
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start vnc_service: $status"
  exit $status
fi

sleep 2

# Start the second process
bash -c "wine explorer /desktop=winbox,1900x1080 '/winbox.exe' &"
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start winbox: $status"
  exit $status
fi

while sleep 10; do
  ps aux |grep vnc_service |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep wineserver |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done
