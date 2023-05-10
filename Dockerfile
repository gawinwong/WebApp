FROM ubuntu:18.04 AS build1
RUN apt update \
 && apt install -y wget git xz-utils \
 && wget https://nodejs.org/dist/v16.16.0/node-v16.16.0-linux-x64.tar.xz \
 && tar -xf node-v16.16.0-linux-x64.tar.xz -C /usr/local/lib/ \
 && wget https://github.com/vercel/pkg-fetch/releases/download/v3.4/node-v16.16.0-linux-x64 \
 && mkdir -p ~/.pkg-cache/v3.4 \
 && mv node-v16.16.0-linux-x64 ~/.pkg-cache/v3.4/fetched-v16.16.0-linux-x64

FROM build1 AS build2
ENV PATH /usr/local/lib/node-v16.16.0-linux-x64/bin:$PATH
COPY WebApp /WebApp
RUN cd /WebApp/ \
 && npm i --legacy-peer-deps \
 && npm run build \
 && npm run pack

FROM ubuntu:18.04
RUN apt update \
 && apt install -y xvfb mesa-utils libgl1-mesa-glx libvulkan1 vulkan-utils libvulkan-dev \
                   fonts-droid-fallback ttf-wqy-zenhei ttf-wqy-microhei fonts-arphic-ukai fonts-arphic-uming \
 && mkdir -p /home/smartview/bin \
 && ln -s /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-encode.so

COPY run.sh /home/smartview/bin/
COPY --from=build1 /usr/local/lib/node-v16.16.0-linux-x64 /home/smartview/bin/node
COPY --from=build2 /WebApp/webserver /home/smartview/bin/

WORKDIR /home/smartview

ENTRYPOINT  ["bin/run.sh"]