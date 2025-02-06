FROM node:alpine

WORKDIR /src

COPY ./src/package.json .
RUN npm install

COPY ./src/ .

EXPOSE 80

CMD ["node", "server.js"]