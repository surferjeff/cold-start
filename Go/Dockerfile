# Stage 1: Build the application
FROM golang:latest AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Go modules dependency file
COPY go.mod go.sum ./

# Download Go modules
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o app

# Stage 2: Create the runtime image
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /root/

# Copy the compiled binary from the previous stage
COPY --from=build /app/app .

# Expose port 8080
EXPOSE 8080

# Command to run the executable
CMD ["./app"]