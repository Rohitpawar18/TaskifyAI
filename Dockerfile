FROM maven:3.8.6-openjdk-11

WORKDIR /app

# Copy files step by step for better debugging
COPY pom.xml .
COPY src ./src

# Debug: Show what files are present
RUN ls -la

# Build with more verbose output
RUN mvn clean package -DskipTests -X

# Show build results
RUN ls -la target/

# Install webapp-runner
RUN mvn dependency:copy -Dartifact=com.heroku:webapp-runner:9.0.52.0 -DoutputDirectory=target/

EXPOSE 8080

CMD ["java", "-version", "&&", "java", "-jar", "target/webapp-runner-9.0.52.0.jar", "target/taskifyai.war", "--port", "8080"]