FROM node:16-alpine3.13

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force

# Bundle app source
COPY . .

CMD [ "npm", "start" ]