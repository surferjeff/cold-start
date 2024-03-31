# # Use a base image with the Java runtime environment
FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/java-app-1.0-SNAPSHOT.jar /app/java-app-1.0-SNAPSHOT.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/java-app-1.0-SNAPSHOT.jar"]