# Stage 1: Build the application
FROM node:20.12.2 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Create the runtime image
FROM node:20.12.2 AS runtime
WORKDIR /app
COPY --from=build /app/node_modules /app/node_modules
COPY --from=build /app/dist /app/dist
EXPOSE 8080
CMD ["node", "./dist/index.js"]