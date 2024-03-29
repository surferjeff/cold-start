# Use a base image with the Java runtime environment
FROM openjdk:11-jre-slim
COPY target/java-app-1.0-SNAPSHOT.jar /app.jar
EXPOSE 7000
ENTRYPOINT ["java", "-jar", "/app.jar"]