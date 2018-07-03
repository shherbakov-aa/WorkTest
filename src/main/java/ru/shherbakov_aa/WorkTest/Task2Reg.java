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

public class Task2Reg extends HttpServlet {
	private static Logger log = Logger.getLogger(Task2Reg.class.getName());
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String responseXml = "";
        String errCode = "0";
        String errText = "";
		Connection connection = null;
		
		String rLogin = CommonFunctions.getStringParam(request, "login");
		String rPassword = CommonFunctions.getStringParam(request, "password");
		int isOperator = CommonFunctions.getIntegerParam(request, "isoperator");
		
		String sessionId = request.getSession().getId();
		
		try {
	     	Document document = CommonFunctions.newDocument();
	            
	        Element resultElement = document.createElement("result");
	        document.appendChild(resultElement);

			try {
		       	Class.forName("org.postgresql.Driver");
		        connection = DriverManager.getConnection(Database.dbUrl, Database.dbLogin, Database.dbPassword);
		        
		        PreparedStatement pstatement = connection.prepareStatement(Database.sqlTask2CheckWebusersExist);
	            pstatement.setString(1, rLogin);
	            ResultSet resultSet = pstatement.executeQuery();
	            int rowCnt = 0;
	            while (resultSet.next()) {
	            	rowCnt ++;
	            }
	            
	            if (rowCnt > 0) {
	            	errCode = "2";
		        	errText = "Пользователь с таким логином уже существует";
	            } else {
			        PreparedStatement psInsert = connection.prepareStatement(Database.sqlTask2InsertWebusers);
			        psInsert.setString(1, rLogin);
			        psInsert.setString(2, sessionId);
			        psInsert.setString(3, rLogin);
			        psInsert.setString(4, rPassword);
			        psInsert.setBoolean(5, isOperator == 1);
			        psInsert.setString(6, sessionId);
				            
			        int resultInt = psInsert.executeUpdate();
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
	    
	    log.info(new StringBuilder().append("Test2 user created. User: ").append(rLogin).append(", SID: ").append(sessionId).toString());
    }
}
