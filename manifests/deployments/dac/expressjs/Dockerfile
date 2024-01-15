FROM node:lts-slim

WORKDIR /work

COPY ./ /work

RUN npm install

USER 1000

CMD [ "node", "server.js" ]
