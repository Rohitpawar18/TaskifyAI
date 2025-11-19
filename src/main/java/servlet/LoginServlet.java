package servlet;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;


public class LoginServlet extends HttpServlet {
    private UserDAO dao = new UserDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String message = "";
        try {
            int userId = dao.validateUser(username, password);
            if (userId > 0) {
                req.getSession().setAttribute("user_id", userId);
                req.getSession().setAttribute("username", username);
                resp.sendRedirect("index.jsp");
                return;
            } else {
                message = "Invalid username or password.";
            }
        } catch (Exception ex) {
            message = "Error: " + ex.getMessage();
        }
        req.setAttribute("message", message);
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }
}
