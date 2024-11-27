FROM amazoncorretto:23-alpine-jdk

ARG JAR_FILE=start/target/*.jar

COPY ${JAR_FILE} app.jar

#COPY .env .env

EXPOSE 3030

ENTRYPOINT ["java","-jar","/app.jar"]