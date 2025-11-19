package util;
import java.sql.*;
import java.net.URI;
import java.net.URISyntaxException;

public class DBUtil {
    public static Connection getConnection() throws Exception {
        try {
            // Check for Render PostgreSQL database URL
            String databaseUrl = System.getenv("DATABASE_URL");
            
            if (databaseUrl != null && databaseUrl.startsWith("postgres")) {
                System.out.println("🔗 Using PostgreSQL database from Render");
                return getPostgreSQLConnection(databaseUrl);
            } else {
                // Fallback to MySQL for local development
                System.out.println("🔗 Using MySQL database for local development");
                return getMySQLConnection();
            }
        } catch (Exception e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    private static Connection getPostgreSQLConnection(String databaseUrl) throws Exception {
        try {
            URI dbUri = new URI(databaseUrl);
            
            String username = dbUri.getUserInfo().split(":")[0];
            String password = dbUri.getUserInfo().split(":")[1];
            String port = String.valueOf(dbUri.getPort());
            String dbUrl = "jdbc:postgresql://" + dbUri.getHost() + ":" + port + dbUri.getPath();
            
            // Add SSL for Render
            if (dbUrl.contains("?")) {
                dbUrl += "&sslmode=require";
            } else {
                dbUrl += "?sslmode=require";
            }
            
            System.out.println("📊 Connecting to PostgreSQL database...");
            
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
    
    // Test connection
    public static void testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("✅ Database connected successfully!");
            System.out.println("📊 Database: " + conn.getMetaData().getDatabaseProductName());
        } catch (Exception e) {
            System.err.println("❌ Database connection failed: " + e.getMessage());
        }
    }
}