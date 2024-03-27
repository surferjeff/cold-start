# Use a base image with the Java runtime environment
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file to the working directory
COPY target/java-app-1.0-SNAPSHOT.jar /app/

EXPOSE 7000

# Set the entry point
ENTRYPOINT ["java", "-jar", "java-app-1.0-SNAPSHOT.jar"]