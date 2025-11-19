package util;
import java.sql.*;
import java.net.URI;
import java.net.URISyntaxException;

public class DBUtil {
    public static Connection getConnection() throws Exception {
        try {
            // Check for Render PostgreSQL database URL first
            String databaseUrl = System.getenv("DATABASE_URL");
            
            if (databaseUrl != null && databaseUrl.startsWith("postgres")) {
                System.out.println("Using PostgreSQL database from environment");
                return getPostgreSQLConnection(databaseUrl);
            } else {
                // Fallback to MySQL for local development
                System.out.println("Using MySQL database for local development");
                return getMySQLConnection();
            }
        } catch (Exception e) {
            System.err.println("Database connection error: " + e.getMessage());
            throw e;
        }
    }
    
    private static Connection getPostgreSQLConnection(String databaseUrl) throws Exception {
        try {
            URI dbUri = new URI(databaseUrl);
            
            String username = dbUri.getUserInfo().split(":")[0];
            String password = dbUri.getUserInfo().split(":")[1];
            String dbUrl = "jdbc:postgresql://" + dbUri.getHost() + ':' + dbUri.getPort() + dbUri.getPath();
            
            // Add SSL for production
            dbUrl += "?sslmode=require";
            
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(dbUrl, username, password);
        } catch (URISyntaxException e) {
            throw new Exception("Invalid DATABASE_URL format", e);
        }
    }
    
    private static Connection getMySQLConnection() throws Exception {
        String url = "jdbc:mysql://localhost:3306/taskifydb";
        String user = "root";
        String password = "dbms";
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, password);
    }
}