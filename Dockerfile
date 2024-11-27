# Stage 1: Build application
FROM eclipse-temurin:23-jdk-alpine AS builder
# Set working directory
WORKDIR /app

# Copy maven/grable and configuration files
COPY mvnw* pom.xml ./
COPY .mvn .mvn

# Copy the modular DDD source code
COPY start/pom.xml start/pom.xml
COPY application/pom.xml application/pom.xml
COPY infrastructure/pom.xml infrastructure/pom.xml
COPY domain/pom.xml domain/pom.xml
COPY controller/pom.xml controller/pom.xml
COPY benchmark/pom.xml benchmark/pom.xml

# Resolve dependencies to leverage caching
RUN ./mvnw dependency:go-offline -B

# Copy the source code for all modules
COPY . .

# Build the application (adjust for Gradle if needed)
RUN ./mvnw clean package -DskipTests -B -q && rm -rf ~/.m2/repository/

#RUN ./mvnw spring-boot:build-image -DskipTests

# Build the project with maven

#RUN ./mvnw clean package -DskipTests

#RUN #ls -la /app/

# Create a lightweight runtime image

FROM eclipse-temurin:23-jre-alpine
# Use a Distroless base image for runtime
#FROM gcr.io/distroless/java17-debian11

# Set metadata
LABEL maintainer="Thang Nguyen <win@ekenzoo.net>" \
      description="Domain-Driven Design Spring Boot application with Java 23"

# Set the working directory

WORKDIR /app

# Copy jar file from the builder stage
COPY --from=builder /app/start/target/*.jar app.jar

# Expose default springboot port

EXPOSE 3030

# Add a user to best security

#RUN addgroup spring && adduser -S spring -G spring
# Add group 'spring' and create a system user 'spring'
RUN addgroup -S spring && adduser -S spring -G spring
#RUN addgroup -r spring && adduser -r spring -G spring
# Add group 'spring' and create a system user 'spring' (appropriate for Debian-based images)
#RUN groupadd -S spring && useradd -S -g spring spring
#USER spring
#RUN addgroup -f spring && adduser -f spring -G spring
USER spring

# Health check

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
CMD curl -f http://localhost:3030/actuator/health || exit 1
# Use optimized JVM settings for containers

ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]