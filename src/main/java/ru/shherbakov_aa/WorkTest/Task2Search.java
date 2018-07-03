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

public class Task2Search extends HttpServlet {
	private static Logger log = Logger.getLogger(Task2Search.class.getName());

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String responseXml = "";
        String errCode = "0";
        String errText = "";
		Connection connection = null;
		
		int toClientId = CommonFunctions.getIntegerParam(request, "client");
        
        try {
        	Document document = CommonFunctions.newDocument();
            
            Element resultElement = document.createElement("result");
            document.appendChild(resultElement);

            Element records = document.createElement("records");
            resultElement.appendChild(records);

            try {
	        	Class.forName("org.postgresql.Driver");
	        	connection = DriverManager.getConnection(Database.dbUrl, Database.dbLogin, Database.dbPassword);
	            
	            PreparedStatement pstatement = connection.prepareStatement(Database.sqlTask2Search);
	            pstatement.setInt(1, toClientId);
	            pstatement.setInt(2, toClientId);
		            
	            ResultSet resultSet = pstatement.executeQuery();
		            
	            while (resultSet.next()) {
	                Element record = document.createElement("record");
	                
	                record.appendChild(CommonFunctions.createXmlElement(document, "lastname", resultSet.getString("from_last_name")));
	                record.appendChild(CommonFunctions.createXmlElement(document, "firstname", resultSet.getString("from_first_name")));
	                record.appendChild(CommonFunctions.createXmlElement(document, "middlename", resultSet.getString("from_middle_name")));
	                record.appendChild(CommonFunctions.createXmlElement(document, "fromlogin", resultSet.getString("from_login")));
	                record.appendChild(CommonFunctions.createXmlElement(document, "to", resultSet.getString("to_client")));
	                record.appendChild(CommonFunctions.createXmlElement(document, "subject", resultSet.getString("subject")));
	                record.appendChild(CommonFunctions.createXmlElement(document, "message", resultSet.getString("message")));
	                record.appendChild(CommonFunctions.createXmlElement(document, "dt", resultSet.getString("created")));
	                
	                records.appendChild(record);
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
    }

}
