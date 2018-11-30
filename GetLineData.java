package my.com.yxcx.line;  
  
import java.io.IOException;  
import java.io.PrintWriter;  
import java.sql.Connection;  
import java.sql.DriverManager;  
import java.sql.ResultSet;  
import java.sql.SQLException;  
import java.sql.Statement;  
import java.util.ArrayList;  
import java.util.List;  
import javax.servlet.ServletException;  
import javax.servlet.http.HttpServlet;  
import javax.servlet.http.HttpServletRequest;  
import javax.servlet.http.HttpServletResponse;  
import com.alibaba.fastjson.JSON;  
  
public class GetLineData extends HttpServlet {  
    public void doGet(HttpServletRequest request, HttpServletResponse response)  
            throws ServletException, IOException {  
        response.setContentType("text/html;charset=utf-8");  
        String driver = "com.mysql.jdbc.Driver";  
        String url = "jdbc:mysql://localhost:3306/D3?zeroDateTimeBehavior=convertToNull&characterEncoding=utf8";  
        String user = "root";  
        String password = "strongs";  
        Connection conn = null;  
        try {  
            Class.forName(driver);  
            conn = DriverManager.getConnection(url, user, password);  
        } catch (SQLException e) {  
            System.err.println(e.getMessage());  
        } catch (ClassNotFoundException e) {  
            System.err.println(e.getMessage());  
        }  
  
        String sql = "select * from line";  
        ResultSet set = null;  
        Statement stmt = null;  
        List<LineEntity> list = new ArrayList<LineEntity>();  
    try {  
    stmt = conn.createStatement();  
    set = stmt.executeQuery(sql);  
    while (set.next()) {  
    LineEntity bean = new LineEntity();  
    bean.setNumber(set.getInt("number"));  
    bean.setDate(set.getString("date"));  
  
    list.add(bean);  
    }  
    } catch (SQLException e) {  
    System.err.println(e.getMessage());  
    }  
  
    String jsonString = JSON.toJSONString(list);  
    System.err.println("GetLineData-----"+jsonString);  
    PrintWriter out = response.getWriter();  
    out.print(jsonString);  
    out.flush();  
    out.close();  
    }  
  
    public void doPost(HttpServletRequest request, HttpServletResponse response)  
    throws ServletException, IOException {  
    doGet(request, response);  
    }  
    } 
