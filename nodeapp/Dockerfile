FROM node:18.12.1
WORKDIR /usr/app
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY . .
EXPOSE 8080
CMD ["node","app.js"]