# Stage 1: Build a custom JRE
FROM eclipse-temurin:23-jdk AS jre-builder

# Create a custom JRE using jlink
RUN /opt/java/openjdk/bin/jlink \
    --module-path /opt/java/openjdk/jmods \
    --add-modules java.base,java.logging,java.xml,java.sql \
    --output /custom-jre \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \

# Stage 1: Build the application
FROM eclipse-temurin:23-jdk-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy Maven wrapper and the main POM file
COPY mvnw* pom.xml ./
COPY .mvn .mvn

# Copy module-specific POM files to resolve dependencies
COPY domain/pom.xml domain/pom.xml
COPY application/pom.xml application/pom.xml
COPY infrastructure/pom.xml infrastructure/pom.xml
COPY controller/pom.xml controller/pom.xml
COPY benchmark/pom.xml benchmark/pom.xml
COPY start/pom.xml start/pom.xml

# Resolve dependencies (caching dependencies layer)
RUN ./mvnw dependency:go-offline -B

# Copy the source code for all modules
COPY . .

# Build the application
RUN ./mvnw clean package -DskipTests -B

# List the contents of /app and /app/target to debug the build output
#RUN ls -la /app/
#RUN ls -la /app/start/target/

# Stage 2: Create a minimal runtime image
#FROM eclipse-temurin:23-jre-alpine
# Stage 3: Create a lightweight runtime image
#FROM alpine:latest
# Stage 3: Create runtime image
FROM debian:bullseye-slim

# Set metadata
LABEL maintainer="Your Name <your.email@example.com>" \
      description="Domain-Driven Design Spring Boot application with Java 23"

# Set the working directory
WORKDIR /app
# Copy the custom JRE
COPY --from=jre-builder /custom-jre /opt/java/custom-jre
ENV PATH="/opt/java/custom-jre/bin:$PATH"
# Copy the built JAR file from the builder stage (adjust the file name if needed)
COPY --from=builder /app/start/target/*.jar app.jar

# Expose the default port
EXPOSE 3030

# Run as non-root user for better security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]
