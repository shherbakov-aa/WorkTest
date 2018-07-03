package ru.shherbakov_aa.WorkTest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


public class Task1ServletAuth extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String userLogin = request.getRemoteUser();
		
        request.setAttribute("userLogin", userLogin);
        request.setAttribute("needAuth", "1");
        
        request.getRequestDispatcher("/task1.jsp").forward(request, response);
    }
    
}