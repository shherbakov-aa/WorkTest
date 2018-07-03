package ru.shherbakov_aa.WorkTest;

import java.io.StringWriter;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class CommonFunctions {

	public static String xmlDocumentToString(Document doc) {
	    try {
	        StringWriter sw = new StringWriter();
	        TransformerFactory tf = TransformerFactory.newInstance();
	        Transformer transformer = tf.newTransformer();
	        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
	        transformer.setOutputProperty(OutputKeys.METHOD, "xml");
	        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
	        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");

	        transformer.transform(new DOMSource(doc), new StreamResult(sw));
	        return sw.toString();
	    } catch (Exception ex) {
	        throw new RuntimeException("Error convert to String", ex);
	    }
	}
	
	public static Element createXmlElement(Document document, String elementName, String elementValue) {
		Element element = document.createElement(elementName);
		element.setTextContent(elementValue);
	    return element;
	}
	
	public static String getStringParam(HttpServletRequest request, String paramName) {
		String result = request.getParameter(paramName);
		if (result == null)
			result = "";
		return result;
	}

	public static int getIntegerParam(HttpServletRequest request, String paramName) {
		String strValue = request.getParameter(paramName);
		int result = 0;
		try {
			result = Integer.parseInt(strValue);
		} catch (NumberFormatException e) {
		}

		return result;
	}

	public static Document newDocument() throws ParserConfigurationException {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	    DocumentBuilder builder = factory.newDocumentBuilder();
	    return builder.newDocument();
	}

	
}


