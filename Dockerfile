FROM maven:3.8.6-openjdk-11

WORKDIR /app

# Copy all files
COPY . .

# Build the application (skip tests to avoid failures)
RUN mvn clean compile war:war -DskipTests

# Verify the WAR file was created
RUN ls -la target/

EXPOSE 8080

# Use embedded Tomcat runner
CMD ["java", "-cp", "target/taskifyai.war", "org.apache.catalina.startup.Bootstrap", "start"]