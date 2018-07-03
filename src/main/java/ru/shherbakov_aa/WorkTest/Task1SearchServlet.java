package ru.shherbakov_aa.WorkTest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.ParserConfigurationException;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class Task1SearchServlet extends HttpServlet {
	private static Logger log = Logger.getLogger(Task1SearchServlet.class.getName());

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
        String responseXml = "";
        String errCode = "0";
        String errText = "";
		Connection connection = null;

		String rLastName = CommonFunctions.getStringParam(request, "lastname");
		String rFirstName = CommonFunctions.getStringParam(request, "firstname");
		String rMiddleName = CommonFunctions.getStringParam(request, "middlename");
		int cityId = CommonFunctions.getIntegerParam(request, "city");
		int carModelId = CommonFunctions.getIntegerParam(request, "car");
		
		log.info(new StringBuilder()	
		       	.append("Task1 Search started with param: ")
				.append("firstname=").append(rFirstName)
				.append(", lastname=").append(rLastName)
				.append(", middlename=").append(rMiddleName)
				.append(", city_id=").append(cityId)
				.append(", carmodel_id=").append(carModelId)
				.toString());
        
		try {
	        Document document = CommonFunctions.newDocument();
	            
	        Element resultElement = document.createElement("result");
	        document.appendChild(resultElement);
	
	        Element records = document.createElement("records");
	        resultElement.appendChild(records);
	
	        if (rLastName == "" && rFirstName == "" && rMiddleName == "" && cityId == 0 && carModelId == 0) {
	        	errCode = "2";
		        errText = "Не выбраны обязательные параметры поиска";            	
	        } else {
		        try {
		        	Class.forName("org.postgresql.Driver");
		        	connection = DriverManager.getConnection(Database.dbUrl, Database.dbLogin, Database.dbPassword);
			            
		            PreparedStatement pstatement = connection.prepareStatement(Database.sqlTask1Search);
		            pstatement.setString(1, rLastName);
		            pstatement.setString(2, rLastName);
		            pstatement.setString(3, rFirstName);
		            pstatement.setString(4, rFirstName);
		            pstatement.setString(5, rMiddleName);
		            pstatement.setString(6, rMiddleName);
		            pstatement.setInt(7, cityId);
		            pstatement.setInt(8, cityId);
		            pstatement.setInt(9, carModelId);
		            pstatement.setInt(10, carModelId);
			            
		            ResultSet resultSet = pstatement.executeQuery();
		            int rowCnt = 0;
			            
		            while (resultSet.next()) {
		                Element record = document.createElement("record");
			                
		                record.appendChild(CommonFunctions.createXmlElement(document, "lastname", resultSet.getString("last_name")));
		                record.appendChild(CommonFunctions.createXmlElement(document, "firstname", resultSet.getString("first_name")));
		                record.appendChild(CommonFunctions.createXmlElement(document, "middlename", resultSet.getString("middle_name")));
		                record.appendChild(CommonFunctions.createXmlElement(document, "city", resultSet.getString("city_name")));
		                record.appendChild(CommonFunctions.createXmlElement(document, "car", resultSet.getString("car_model")));
		                record.appendChild(CommonFunctions.createXmlElement(document, "color", resultSet.getString("color_name")));
		                record.appendChild(CommonFunctions.createXmlElement(document, "regnumber", resultSet.getString("reg_number")));
		                
		                records.appendChild(record);
		                rowCnt ++;
		            }
		            log.info(new StringBuilder().append("Task1 Search finished. RowCnt: ").append(rowCnt).toString());
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
