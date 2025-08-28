FROM node:current-alpine3.22

RUN apk update
RUN apk add make bash git
RUN npm install --global resume-cli jsonresume-theme-paper-plus-plus

USER node
