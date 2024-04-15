# # Stage 1: Build the application
# FROM node:20.12.2 AS build
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run build

# # Stage 2: Create the runtime image
# FROM node:20.12.2 AS runtime
# WORKDIR /app
# COPY package*.json ./
# RUN npm install --only=production
# COPY --from=build /app/dist ./dist
# EXPOSE 8080

# # Command to run the application
# CMD ["node", "./dist/index.js"]

FROM node:20.12.2
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080

CMD ["node", "index.js"]