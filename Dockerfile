FROM gradle:7.3.1-jdk17 AS builder
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle bootJar --no-daemon


FROM openjdk:11
EXPOSE 8080


ENV LIGHTRUN_KEY=b0ec4ae2-e711-4ad5-98d9-f2ac028c093e

RUN mkdir /app
COPY agent/*.* app/

COPY --from=builder /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar
CMD ["java", "-jar","-agentpath:/app/lightrun_agent.so", "/app/spring-boot-application.jar"]
