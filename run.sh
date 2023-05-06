#!/bin/sh

cd /home/smartview/client/
nohup xvfb-run -a ./smartview.x86_64 -screen-width 1920 -screen-height 1080 -signalingUrl ws://127.0.0.1:$STREAMPORT &
cd /home/smartview/bin
./webserver -t websocket -p $STREAMPORT