FROM openjdk:11

WORKDIR /app
COPY . .

# Build the application
RUN mvn clean package -DskipTests

# Expose port
EXPOSE 8080

# Run with embedded Tomcat (if you have spring-boot) or adjust for your setup
CMD ["java", "-jar", "target/taskifyai.war"]