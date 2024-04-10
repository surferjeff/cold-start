# Stage 1: Build the application
FROM node:latest AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the source code into the container
COPY . .

# Build the Node.js application
RUN npm run build

# Stage 2: Create the runtime image
FROM node:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the built application from the previous stage
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json .

# Expose port (if needed)
# EXPOSE 3000

# Command to run the application
CMD ["node", "./dist/index.js"]