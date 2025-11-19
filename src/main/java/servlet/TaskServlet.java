package servlet;
import util.NLP;
import util.NLP.ParsedCommand;
import dao.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.*;

public class TaskServlet extends HttpServlet {
    private TaskDAO dao = new TaskDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = (String) req.getSession().getAttribute("username");
        if (username == null) { 
            resp.sendRedirect("login.jsp"); 
            return; 
        }
        
        String action = req.getParameter("action"); 
        String msg = "";
        List<Map<String, String>> tasks = new ArrayList<>();

        try {
            if (action == null) {
                String command = req.getParameter("input");
                if (command != null && !command.trim().isEmpty()) {
                    NLP.ParsedCommand pc = NLP.parse(command);
                    if (pc == null) {
                        msg = "Invalid command! Please use format: 'create task [description] with [priority] priority by [date]'";
                    } else if ("create".equals(pc.action)) {
                        dao.addTask(username, pc.argument, pc.priority, pc.deadline);
                        msg = "Task created successfully via NLP!";
                    } else if ("show".equals(pc.action)) {
                        tasks = dao.fetchTasksForUser(username);
                        req.setAttribute("tasks", tasks);
                        req.getRequestDispatcher("show_tasks.jsp").forward(req, resp);
                        return;
                    } else if ("delete".equals(pc.action)) {
                        if (pc.id != null && !pc.id.isEmpty()) {
                            int id = Integer.parseInt(pc.id);
                            dao.deleteTask(username, id);
                            msg = "Task deleted successfully!";
                        } else {
                            msg = "Error: Task ID not specified for deletion";
                        }
                    } else if ("update".equals(pc.action)) {
                        if (pc.id != null && !pc.id.isEmpty()) {
                            int id = Integer.parseInt(pc.id);
                            dao.updateTaskStatus(username, id, pc.priority != null ? pc.priority : "done");
                            msg = "Task updated successfully!";
                        } else {
                            msg = "Error: Task ID not specified for update";
                        }
                    }
                } else {
                    msg = "Error: No command provided";
                }
            }
            else if ("createStandard".equals(action)) {
                String desc = req.getParameter("desc");
                String priority = req.getParameter("priority");
                String dlS = req.getParameter("deadline");
                java.sql.Date deadline = (dlS == null || dlS.isEmpty()) ? null : java.sql.Date.valueOf(dlS);
                
                if (desc != null && !desc.trim().isEmpty()) {
                    dao.addTask(username, desc, priority, deadline);
                    msg = "Task created successfully!";
                } else {
                    msg = "Error: Task description cannot be empty";
                }
            }
            else if ("updateStatus".equals(action)) {
                String taskIdStr = req.getParameter("task_id");
                if (taskIdStr != null && !taskIdStr.isEmpty()) {
                    int id = Integer.parseInt(taskIdStr);
                    String status = req.getParameter("status");
                    dao.updateTaskStatus(username, id, status); 
                    msg = "Task marked as " + status + "!";
                } else {
                    msg = "Error: Task ID not specified";
                }
            }
            else if ("edit".equals(action)) {
                String taskIdStr = req.getParameter("task_id");
                if (taskIdStr != null && !taskIdStr.isEmpty()) {
                    int id = Integer.parseInt(taskIdStr);
                    String desc = req.getParameter("desc");
                    String status = req.getParameter("status");
                    String priority = req.getParameter("priority");
                    String dlS = req.getParameter("deadline");
                    java.sql.Date deadline = (dlS == null || dlS.isEmpty()) ? null : java.sql.Date.valueOf(dlS);
                    
                    if (desc != null && !desc.trim().isEmpty()) {
                        dao.updateTaskDetails(username, id, desc, status, priority, deadline);
                        msg = "Task updated successfully!";
                    } else {
                        msg = "Error: Task description cannot be empty";
                    }
                } else {
                    msg = "Error: Task ID not specified";
                }
            }
            else if ("delete".equals(action)) {
                String taskIdStr = req.getParameter("task_id");
                if (taskIdStr != null && !taskIdStr.isEmpty()) {
                    int id = Integer.parseInt(taskIdStr);
                    dao.deleteTask(username, id); 
                    msg = "Task deleted successfully!";
                } else {
                    msg = "Error: Task ID not specified";
                }
            }
        } catch (NumberFormatException ex) {
            msg = "Error: Invalid task ID format";
        } catch (Exception ex) { 
            msg = "Error: " + ex.getMessage(); 
            ex.printStackTrace();
        }

        // Always fetch updated tasks
        try {
            tasks = dao.fetchTasksForUser(username);
        } catch (Exception ex) { 
            msg += " (Could not fetch tasks: " + ex.getMessage() + ")"; 
        }
        
        req.setAttribute("tasks", tasks);
        req.setAttribute("message", msg);
        req.getRequestDispatcher("show_tasks.jsp").forward(req, resp);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = (String) req.getSession().getAttribute("username");
        if (username == null) { 
            resp.sendRedirect("login.jsp"); 
            return; 
        }
        
        String msg = "";
        List<Map<String, String>> tasks = new ArrayList<>();
        
        try {
            tasks = dao.fetchTasksForUser(username);
        } catch (Exception ex) {
            msg = "Error fetching tasks: " + ex.getMessage();
        }
        
        req.setAttribute("tasks", tasks);
        req.setAttribute("message", msg);
        req.getRequestDispatcher("show_tasks.jsp").forward(req, resp);
    }
}