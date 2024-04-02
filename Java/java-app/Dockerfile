FROM maven AS build

COPY src /app/src
COPY pom.xml /app/pom.xml

RUN mvn -f /app/pom.xml clean package

FROM openjdk:11-jre-slim AS runtime
WORKDIR /app
COPY --from=build /app/target/java-app-1.0-SNAPSHOT.jar /app/java-app-1.0-SNAPSHOT.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/java-app-1.0-SNAPSHOT.jar"]