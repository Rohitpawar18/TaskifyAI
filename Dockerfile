# Build stage
FROM maven:3.8.6-openjdk-11 AS builder

WORKDIR /app
COPY . .

# Build the WAR file
RUN mvn clean package -DskipTests

# Verify the WAR file was created
RUN ls -la target/*.war

# Runtime stage - Use official Tomcat image
FROM tomcat:9.0-jre11

# Remove default Tomcat apps to save space
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy our WAR file to Tomcat webapps (rename to ROOT.war to make it the root app)
COPY --from=builder /app/target/taskifyai.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 (Tomcat's default)
EXPOSE 8080

# Tomcat starts automatically, no need for CMD