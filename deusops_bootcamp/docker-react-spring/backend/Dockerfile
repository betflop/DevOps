FROM maven:3.8.2-openjdk-16-slim as builder
WORKDIR /usr/src/app
COPY ./src ./src
COPY *.xml ./
RUN mvn package -Dmaven.test.skip=true

FROM openjdk:16-jdk
# RUN apk update && apk upgrade
# RUN apt update && apt -y install curl && apt install mysql-client
WORKDIR /app
COPY --from=builder /usr/src/app/target/*.jar ./app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
