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

public class Task1GetCars extends HttpServlet {
	private static Logger log = Logger.getLogger(Task1GetCars.class.getName());
    
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String responseXml = "";
        String errCode = "0";
        String errText = "";
		Connection connection = null;
       
        try {
        	Document document = CommonFunctions.newDocument();
            
            Element resultElement = document.createElement("result");
            document.appendChild(resultElement);

            Element cars = document.createElement("cars");
            resultElement.appendChild(cars);

	        try {
		       	Class.forName("org.postgresql.Driver");
		       	connection = DriverManager.getConnection(Database.dbUrl, Database.dbLogin, Database.dbPassword);
		
		       	Statement statement = connection.createStatement();
		       	ResultSet resultSet = statement.executeQuery(Database.sqlTask1GetCars);
		            
	            while (resultSet.next()) {
	                Element car = document.createElement("car");
	                
	                car.appendChild(CommonFunctions.createXmlElement(document, "id", resultSet.getString("id")));
	                car.appendChild(CommonFunctions.createXmlElement(document, "name", resultSet.getString("name")));
		               
	                cars.appendChild(car);
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


