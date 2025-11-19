package dao;
import util.DBUtil;
import java.sql.*;
import java.util.*;

public class TaskDAO {
    private String getTable(String username) {
        return "tasks_" + username.replaceAll("\\W+", "");
    }

    public void addTask(String username, String desc, String priority, java.sql.Date deadline) throws Exception {
        String sql = "INSERT INTO " + getTable(username) + " (description, status, priority, deadline) VALUES (?, 'Pending', ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, desc);
            ps.setString(2, priority);
            if (deadline != null) ps.setDate(3, deadline); else ps.setNull(3, java.sql.Types.DATE);
            ps.executeUpdate();
        }
    }

    public List<Map<String, String>> fetchTasksForUser(String username) throws Exception {
        String sql = "SELECT * FROM " + getTable(username);
        List<Map<String, String>> tasks = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, String> t = new HashMap<>();
                t.put("id", String.valueOf(rs.getInt("task_id")));
                t.put("desc", rs.getString("description"));
                t.put("status", rs.getString("status"));
                t.put("priority", rs.getString("priority"));
                t.put("deadline", rs.getDate("deadline") != null ? rs.getDate("deadline").toString() : "");
                tasks.add(t);
            }
        }
        return tasks;
    }

    public void updateTaskStatus(String username, int taskId, String status) throws Exception {
        String sql = "UPDATE " + getTable(username) + " SET status=? WHERE task_id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, taskId);
            ps.executeUpdate();
        }
    }

    public void updateTaskDetails(String username, int taskId, String desc, String status, String priority, java.sql.Date deadline) throws Exception {
        String sql = "UPDATE " + getTable(username) + " SET description=?, status=?, priority=?, deadline=? WHERE task_id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, desc); ps.setString(2, status); ps.setString(3, priority);
            if (deadline != null) ps.setDate(4, deadline); else ps.setNull(4, java.sql.Types.DATE);
            ps.setInt(5, taskId);
            ps.executeUpdate();
        }
    }

    public void deleteTask(String username, int taskId) throws Exception {
        String sql = "DELETE FROM " + getTable(username) + " WHERE task_id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            ps.executeUpdate();
        }
    }
}
