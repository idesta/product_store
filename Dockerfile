# Use official Node image
FROM node:latest

# Set working directory

WORKDIR /app

# Copy files
COPY package*.json ./

RUN npm install

COPY . .

# EXPOSE 5000
EXPOSE 5000

# Run app

CMD ["npm", "start"]
