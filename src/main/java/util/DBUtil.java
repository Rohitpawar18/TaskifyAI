package util;
import java.sql.*;
import java.net.URI;
import java.net.URISyntaxException;

public class DBUtil {
    private static final boolean DB_DEBUG = System.getenv("DB_DEBUG") != null;
    
    public static Connection getConnection() throws Exception {
        try {
            // Check for Render PostgreSQL database URL first
            String databaseUrl = System.getenv("DATABASE_URL");
            
            if (databaseUrl != null && databaseUrl.startsWith("postgres")) {
                if (DB_DEBUG) {
                    System.out.println("🔗 Using PostgreSQL database from Render");
                    System.out.println("📊 DATABASE_URL: " + 
                        databaseUrl.replaceAll(":[^:]*@", ":****@"));
                }
                return getPostgreSQLConnection(databaseUrl);
            } else {
                // Fallback to MySQL for local development
                if (DB_DEBUG) {
                    System.out.println("🔗 Using MySQL database for local development");
                }
                return getMySQLConnection();
            }
        } catch (Exception e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
            if (DB_DEBUG) {
                e.printStackTrace();
            }
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
            
            // Add SSL for production
            if (dbUrl.contains("?")) {
                dbUrl += "&sslmode=require";
            } else {
                dbUrl += "?sslmode=require";
            }
            
            if (DB_DEBUG) {
                System.out.println("📊 Connecting to PostgreSQL: " + dbUri.getHost() + dbUri.getPath());
            }
            
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, username, password);
            
            if (DB_DEBUG) {
                System.out.println("✅ PostgreSQL connection established successfully");
            }
            
            return conn;
        } catch (URISyntaxException e) {
            throw new Exception("Invalid DATABASE_URL format: " + databaseUrl, e);
        }
    }
    
    private static Connection getMySQLConnection() throws Exception {
        String url = "jdbc:mysql://localhost:3306/taskifydb";
        String user = "root";
        String password = "dbms";
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, password);
    }
    
    public static void testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("✅ Database connected successfully!");
            System.out.println("📊 Database: " + conn.getMetaData().getDatabaseProductName());
            System.out.println("🔗 URL: " + conn.getMetaData().getURL());
        } catch (Exception e) {
            System.err.println("❌ Database connection failed: " + e.getMessage());
        }
    }
}