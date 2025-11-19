package servlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;

public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getSession().invalidate();
        resp.sendRedirect("login.jsp");
    }
}
