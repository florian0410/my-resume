FROM node:current-alpine3.15

RUN apk add make
RUN npm install -g resume-cli

USER node
