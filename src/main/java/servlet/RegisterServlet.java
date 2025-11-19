package servlet;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;

public class RegisterServlet extends HttpServlet {
    private UserDAO dao = new UserDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String message = "";
        try {
            boolean success = dao.registerUser(username, password);
            if (success) {
                String tableName = "tasks_" + username.replaceAll("\\W+", ""); // sanitize username
             // In RegisterServlet.java - update table creation
                String sql = "CREATE TABLE " + tableName + " (" +
                    "task_id SERIAL PRIMARY KEY," +  // SERIAL for PostgreSQL
                    "description VARCHAR(255) NOT NULL," +
                    "status VARCHAR(20) DEFAULT 'Pending'," +
                    "priority VARCHAR(10) DEFAULT 'Medium'," +
                    "deadline DATE," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")";
                try (java.sql.Connection con = util.DBUtil.getConnection();
                     java.sql.Statement st = con.createStatement()) {
                    st.executeUpdate(sql);
                }
                message = "Registration successful. You can now log in.";
                req.setAttribute("message", message);
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            } else {
                message = "Username already exists. Please choose a different username.";
            }
        } catch (Exception ex) {
            message = "Error: " + ex.getMessage();
        }
        req.setAttribute("message", message);
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }
}
