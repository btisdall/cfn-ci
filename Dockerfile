FROM node:8.7.0-alpine

RUN apk --update add \
  jq \
  ;

RUN npm install -g \
  cfn-create-or-update \
  ;

COPY bin/create-or-update /usr/local/bin/
COPY bin/Makefile /files/
