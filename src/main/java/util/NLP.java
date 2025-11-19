package util;
import java.text.*;
import java.util.*;
import java.util.regex.*;

public class NLP {
    public static ParsedCommand parse(String cmd) {
        if (cmd == null || cmd.trim().isEmpty()) {
            return null;
        }
        
        cmd = cmd.toLowerCase().trim();
        
        // Show tasks command
        if (cmd.matches("^(show|list|display).*task.*")) {
            return new ParsedCommand("show", null, null, null, null, null);
        }
        
        // Create task command
        if (cmd.matches("^(create|add|new).*task.*")) {
            String desc = extractDescription(cmd);
            String priority = extractPriority(cmd);
            java.sql.Date deadline = extractDeadline(cmd);
            
            return new ParsedCommand("create", desc, priority, deadline, null, null);
        }
        
        // Delete task command
        if (cmd.matches("^(delete|remove).*task.*")) {
            String id = extractId(cmd);
            return new ParsedCommand("delete", null, null, null, id, null);
        }
        
        // Update task command
        if (cmd.matches("^(update|modify|change|mark).*task.*")) {
            String id = extractId(cmd);
            String status = extractStatus(cmd);
            String priority = extractPriority(cmd);
            
            return new ParsedCommand("update", null, priority, null, id, status);
        }
        
        return null;
    }
    
    private static String extractDescription(String cmd) {
        // Remove command prefixes
        String desc = cmd.replaceAll("^(create|add|new)\\s+task\\s*", "");
        
        // Remove priority phrases
        desc = desc.replaceAll("\\s+with\\s+(high|medium|low)\\s+priority", "");
        desc = desc.replaceAll("\\s+(high|medium|low)\\s+priority", "");
        
        // Remove deadline phrases
        desc = desc.replaceAll("\\s+by\\s+\\d{4}-\\d{2}-\\d{2}.*", "");
        desc = desc.replaceAll("\\s+deadline.*", "");
        
        return desc.trim();
    }
    
    private static String extractPriority(String cmd) {
        if (cmd.contains("high priority") || cmd.contains("priority high")) {
            return "High";
        } else if (cmd.contains("low priority") || cmd.contains("priority low")) {
            return "Low";
        } else if (cmd.contains("medium priority") || cmd.contains("priority medium")) {
            return "Medium";
        }
        
        // Default priority
        return "Medium";
    }
    
    private static java.sql.Date extractDeadline(String cmd) {
        Pattern datePattern = Pattern.compile("\\b(\\d{4}-\\d{2}-\\d{2})\\b");
        Matcher matcher = datePattern.matcher(cmd);
        
        if (matcher.find()) {
            String dateStr = matcher.group(1);
            try {
                java.util.Date d = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
                return new java.sql.Date(d.getTime());
            } catch (ParseException ignored) {}
        }
        
        // Also check for "by" followed by date
        if (cmd.contains("by")) {
            String[] parts = cmd.split("by");
            if (parts.length > 1) {
                matcher = datePattern.matcher(parts[1]);
                if (matcher.find()) {
                    String dateStr = matcher.group(1);
                    try {
                        java.util.Date d = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
                        return new java.sql.Date(d.getTime());
                    } catch (ParseException ignored) {}
                }
            }
        }
        
        return null;
    }
    
    private static String extractId(String cmd) {
        Pattern idPattern = Pattern.compile("(?:task\\s+)?(\\d+)");
        Matcher matcher = idPattern.matcher(cmd);
        
        if (matcher.find()) {
            return matcher.group(1);
        }
        
        return null;
    }
    
    private static String extractStatus(String cmd) {
        if (cmd.contains("done") || cmd.contains("complete") || cmd.contains("finished")) {
            return "done";
        } else if (cmd.contains("pending") || cmd.contains("in progress")) {
            return "Pending";
        }
        
        return null;
    }
    
    public static class ParsedCommand {
        public String action, argument, priority, id;
        public java.sql.Date deadline;
        public String status;
        
        public ParsedCommand(String action, String argument, String priority, java.sql.Date deadline, String id, String status) {
            this.action = action; 
            this.argument = argument; 
            this.priority = priority; 
            this.deadline = deadline; 
            this.id = id; 
            this.status = status;
        }
    }
}