package dao;
import util.DBUtil;
import java.sql.*;

public class UserDAO {
    public int validateUser(String username, String password) throws Exception {
        String sql = "SELECT user_id FROM users WHERE username=? AND password=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("user_id");
            }
        }
        return -1;
    }
    public boolean registerUser(String username, String password) throws Exception {
        String sql = "INSERT INTO users (username, password) VALUES (?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username); ps.setString(2, password);
            ps.executeUpdate();
            return true;
        } catch (SQLIntegrityConstraintViolationException e) {
            return false;
        }
    }
}
