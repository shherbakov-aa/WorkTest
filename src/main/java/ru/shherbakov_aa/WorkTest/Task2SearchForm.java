package ru.shherbakov_aa.WorkTest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Task2SearchForm extends HttpServlet {
	private static Logger log = Logger.getLogger(Task2SearchForm.class.getName());

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection connection = null;
		String sessionId = request.getSession().getId();
		String userLogin = "";
		boolean isOperator = false;
		
		try {
	       	Class.forName("org.postgresql.Driver");
	        connection = DriverManager.getConnection(Database.dbUrl, Database.dbLogin, Database.dbPassword);
	        
	        PreparedStatement pstatement = connection.prepareStatement(Database.sqlTask2CheckWebusersSessionid);
            pstatement.setString(1, sessionId);
            ResultSet resultSet = pstatement.executeQuery();
            while (resultSet.next()) {
            	userLogin = resultSet.getString("login");
            	isOperator = resultSet.getBoolean("is_operator");
            }
        } catch (Exception ex) {
        	ex.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException ex) {
                	log.log(Level.SEVERE, "Exception: ", ex);
                }
            }
        }
		
		if (userLogin.equals(""))
			response.sendRedirect("task2_loginform?target=task2_searchform");
		else 
			if (!isOperator) {
				String message = "Вы вошли под пользователем " + userLogin + ", не имеющим привелегий оператора. Необходимо зайти под другим пользователем.";
				response.sendRedirect("task2_loginform?target=task2_searchform&message=" + URLEncoder.encode(message, "UTF-8").replaceAll("\\+", "%20"));
			}
			else {
				request.setAttribute("userLogin", userLogin);
				request.getRequestDispatcher("/task2_search.jsp").forward(request, response);
			}
    }
}