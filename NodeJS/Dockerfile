# base
FROM node:17.9.0 AS base
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# build
FROM linter as builder
WORKDIR /app
RUN npm run build

# production
FROM node:17.9.0-alpine3.15
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY --from=builder /app/dist ./
EXPOSE 3000
CMD ["node", "index.js"]