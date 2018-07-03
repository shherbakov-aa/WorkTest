package ru.shherbakov_aa.WorkTest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.w3c.dom.Element;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Task2SendForm extends HttpServlet {
	private static Logger log = Logger.getLogger(Task2SendForm.class.getName());

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		Connection connection = null;
		String sessionId = request.getSession().getId();
		String userLogin = "";
		
		try {
	       	Class.forName("org.postgresql.Driver");
	        connection = DriverManager.getConnection(Database.dbUrl, Database.dbLogin, Database.dbPassword);
	        
	        PreparedStatement pstatement = connection.prepareStatement(Database.sqlTask2CheckWebusersSessionid);
            pstatement.setString(1, sessionId);
            ResultSet resultSet = pstatement.executeQuery();
            while (resultSet.next()) {
            	userLogin = resultSet.getString("login");
            }
        } catch (Exception ex) {
        	log.log(Level.SEVERE, "Exception: ", ex);
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException ex) {
                	log.log(Level.SEVERE, "Exception: ", ex);
                }
            }
        }
		if (!userLogin.equals(""))
			request.setAttribute("userLogin", userLogin);
		
        request.getRequestDispatcher("/task2_send.jsp").forward(request, response);
    }

}