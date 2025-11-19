# Build stage
FROM maven:3.8.6-openjdk-11 AS builder

# Set working directory
WORKDIR /app

# Copy pom.xml first (for better caching)
COPY pom.xml .

# Copy source code
COPY src/ ./src/

# Build the application
RUN mvn clean package -DskipTests

# Download webapp-runner
RUN mvn dependency:copy -Dartifact=com.heroku:webapp-runner:9.0.52.0 -DoutputDirectory=target/

# Runtime stage
FROM openjdk:11-jre-slim

# Install curl for health checks
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set working directory
WORKDIR /app

# Copy the built WAR file from builder stage
COPY --from=builder /app/target/taskifyai.war .

# Copy webapp-runner
COPY --from=builder /app/target/webapp-runner-9.0.52.0.jar ./webapp-runner.jar

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Run the application
CMD ["java", "-jar", "webapp-runner.jar", "taskifyai.war", "--port", "8080"]