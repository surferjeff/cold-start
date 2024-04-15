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

# Copy the build output to the runtime image
COPY --from=build /app/dist /app

# run npm install for production
RUN npm install --only=production

# copy the source code
COPY distapp ./

EXPOSE 8080

# Command to run the application
CMD ["node", "./index.js"]