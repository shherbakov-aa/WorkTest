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

public class Task2Send extends HttpServlet {
	private static Logger log = Logger.getLogger(Task2Send.class.getName());
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
        String responseXml = "";
        String errCode = "0";
        String errText = "";
		Connection connection = null;
		
		String rLastName = CommonFunctions.getStringParam(request, "fromlastname");
		String rFirstName = CommonFunctions.getStringParam(request, "fromfirstname");
		String rMiddleName = CommonFunctions.getStringParam(request, "frommiddlename");
		int toClientId = CommonFunctions.getIntegerParam(request, "client");
		String rSubject = CommonFunctions.getStringParam(request, "subject");
		String rMessage = CommonFunctions.getStringParam(request, "message");
		String sessionId = request.getSession().getId();
        
        try {
        	Document document = CommonFunctions.newDocument();
            
            Element resultElement = document.createElement("result");
            document.appendChild(resultElement);

            try {
	        	Class.forName("org.postgresql.Driver");
	            connection = DriverManager.getConnection(Database.dbUrl, Database.dbLogin, Database.dbPassword);
		            
	            PreparedStatement pstatement = connection.prepareStatement(Database.sqlTask2InsertRequests);
	            pstatement.setString(1, rFirstName);
	            pstatement.setString(2, rLastName);
	            pstatement.setString(3, rMiddleName);
	            pstatement.setString(4, sessionId);
	            pstatement.setInt(5, toClientId);
	            pstatement.setString(6, rSubject);
	            pstatement.setString(7, rMessage);
		        
	            int resultInt = pstatement.executeUpdate();
	            resultElement.appendChild(CommonFunctions.createXmlElement(document, "sqlResult", "" + resultInt));

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
    }
}
