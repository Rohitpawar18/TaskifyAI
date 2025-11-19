FROM maven:3.8.6-openjdk-11

# Set memory limits for Maven build (JVM level, not compiler level)
ENV MAVEN_OPTS="-Xmx512m -Xms256m"

WORKDIR /app

# Copy all files
COPY . .

# Build the application
RUN mvn clean compile war:war -DskipTests

# Verify the WAR file was created
RUN ls -la target/

EXPOSE 8080

# Use webapp-runner for Tomcat
CMD ["java", "-jar", "target/dependency/webapp-runner.jar", "target/taskifyai.war", "--port", "8080"]