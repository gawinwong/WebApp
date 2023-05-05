FROM ubuntu:18.04 AS build1
RUN apt-get update \
 && apt-get install -y wget git xz-utils \
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