FROM gradle:8.11.0-jdk17-corretto-al2023 AS builder

WORKDIR /app

COPY build.gradle settings.gradle ./
COPY gradle ./gradle

RUN gradle build -i --stacktrace -x test || return 0

COPY . .

RUN gradle build -x test


FROM amazoncorretto:17-alpine3.20-jdk

WORKDIR /app

COPY --from=builder /app/build/libs/*-all.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
CMD []