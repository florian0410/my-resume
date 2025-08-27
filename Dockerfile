FROM node:current-alpine3.22

RUN apk update
RUN apk add make bash git
RUN npm install -g resume-cli

USER node
