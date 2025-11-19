# Simple working Dockerfile
FROM maven:3.8.6-openjdk-11

WORKDIR /app
COPY . .

# Build the application
RUN mvn clean package -DskipTests

# Install webapp-runner
RUN mvn dependency:copy -Dartifact=com.heroku:webapp-runner:9.0.52.0 -DoutputDirectory=target/

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "target/webapp-runner-9.0.52.0.jar", "target/taskifyai.war", "--port", "8080"]