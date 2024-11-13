# Stage 1: Build the application
FROM gradle:8-jdk21-alpine AS build

# Set the working directory
WORKDIR /app

# Copy the Gradle wrapper and build files
COPY gradle-wrapper.* build.gradle settings.gradle /app/

# Copy the source code into the container
COPY src /app/src/

# Build the application using Gradle
RUN gradle build --no-daemon

# Stage 2: Create the runtime image
FROM openjdk:21-jdk-slim as runtime

# Set the working directory
WORKDIR /app

# Copy the jar from the build stage
COPY --from=build /app/build/libs/*.jar /app/app.jar

# Expose the application port (default Spring Boot port is 8080)
EXPOSE 8761

# Command to run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
