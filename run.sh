#!/bin/bash

source /opt/ros/melodic/setup.bash
nohup roscore &
sleep 1
nohup bash /smartview/scripts/websocket_server.sh &
sleep 1
nohup bash /smartview/scripts/smartview.sh &

cd /smartview/client/
nohup xvfb-run -a ./smartview.x86_64 -p $WS_PORT -screen-width 1920 -screen-height 1080 -signalingUrl ws://127.0.0.1:$STREAMPORT &
cd /smartview_stream
./webserver -t websocket -p $STREAMPORT