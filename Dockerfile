FROM maven:3.8.6-openjdk-11

WORKDIR /app
COPY . .

# Build the application
RUN mvn clean package -DskipTests

# Download webapp-runner directly to target directory
RUN wget -q -O target/webapp-runner.jar \
    https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.52.0/webapp-runner-9.0.52.0.jar

EXPOSE 8080

CMD ["java", "-jar", "target/webapp-runner.jar", "target/taskifyai.war", "--port", "8080"]