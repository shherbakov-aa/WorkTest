package ru.shherbakov_aa.WorkTest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class Task2Login extends HttpServlet {
	private static Logger log = Logger.getLogger(Task2Login.class.getName());
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String responseXml = "";
        String errCode = "0";
        String errText = "";
		Connection connection = null;
		
		String rLogin = CommonFunctions.getStringParam(request, "login");
		String rPassword = CommonFunctions.getStringParam(request, "password");
		
		String sessionId = request.getSession().getId();
		
		try {
	     	Document document = CommonFunctions.newDocument();
	            
	        Element resultElement = document.createElement("result");
	        document.appendChild(resultElement);

			try {
		       	Class.forName("org.postgresql.Driver");
		        connection = DriverManager.getConnection(Database.dbUrl, Database.dbLogin, Database.dbPassword);
		        
		        PreparedStatement pstatement = connection.prepareStatement(Database.sqlTask2CheckLoginPassword);
	            pstatement.setString(1, rLogin);
	            pstatement.setString(2, rPassword);
	            ResultSet resultSet = pstatement.executeQuery();
	            int rowCnt = 0;
	            while (resultSet.next()) {
	            	rowCnt ++;
	            }
	            
	            if (rowCnt == 0) {
	            	errCode = "2";
		        	errText = "Введены неверно логин или пароль";
	            } else {
			        PreparedStatement psUpdate = connection.prepareStatement(Database.sqlTask2SetWebuserSessionid);
			        psUpdate.setString(1, sessionId);
			        psUpdate.setString(2, rLogin);
			        psUpdate.setString(3, sessionId);
			        psUpdate.setString(4, rLogin);
				            
			        int resultInt = psUpdate.executeUpdate();
			        resultElement.appendChild(CommonFunctions.createXmlElement(document, "sqlResult", "" + resultInt));
	            }
	
	        } catch (Exception ex) {
	        	errCode = "1";
	        	errText = "Ошибка выполннения запроса";
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
        
	        resultElement.appendChild(CommonFunctions.createXmlElement(document, "errCode", errCode));
	        resultElement.appendChild(CommonFunctions.createXmlElement(document, "errText", errText));
	        
	        responseXml = CommonFunctions.xmlDocumentToString(document);
	        
        } catch (ParserConfigurationException ex) {
        	log.log(Level.SEVERE, "Exception: ", ex);
        }
        
        response.setContentType("application/xml; charset=UTF-8");
	    response.getWriter().write(new String(responseXml));
	    
	    log.info(new StringBuilder().append("Test2 login success. User: ").append(rLogin).append(", SID: ").append(sessionId).toString());
    }
}
