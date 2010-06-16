<%-- 
    Document   : index
    Created on : Apr 24, 2010, 12:06:28 AM
    Author     : NKLapTop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="BUS.*,DTO.*" %>

<%!
private DTO_JPOS_Admin Login(String strUsername, String strPassword) {
    if (strUsername == "" || strPassword == "") {
        return null;
    }
    return BUS_JPOS_Admin.Login(strUsername, strPassword, DAO.DataProvider.getConnection(this.getServletConfig()));
};
%>

<%
    int iTaskID = -1;
    DTO_JPOS_Issuer issuer = BUS.BUS_JPOS_Issuer.getIssuer(DAO.DataProvider.getConnection(this.getServletConfig()));            
    String strTask = request.getParameter("TaskID");
    if (strTask != null)
        try{
            iTaskID = Integer.parseInt(strTask);
        }catch (Exception ex){
            iTaskID = -1;
        }
    switch (iTaskID){
        case 0:
            String strUsername = request.getParameter("txtUsername");
            String strPassword = request.getParameter("txtPassword");
            DTO_JPOS_Admin DTO_admin = Login(strUsername, strPassword);
            session.setAttribute("Admin",DTO_admin);            
            %> <%@include file="views/IndexPage.jsp" %>  <%
            break;
        case 1:
            session.removeAttribute("Admin");
            %> <%@include file="views/IndexPage.jsp" %>  <%
            break;
        case 2 :
        case 3 :
        case 4 :
        case 5 :
            %> <jsp:forward page="controller/client.jsp"></jsp:forward> <%
            break;
        case 6 :
            %> <jsp:forward page="controller/customer.jsp"></jsp:forward> <%
            break;
        case 7 :
            %> <jsp:forward page="controller/terminal.jsp"></jsp:forward> <%
            break;
        case 8 :
            %> <jsp:forward page="controller/merchant.jsp"></jsp:forward> <%
            break;
        case 9 :
            %> <jsp:forward page="controller/card.jsp"></jsp:forward> <%
            break;
        case 10 :
        case 11 :
        case 12 :
        case 13 :
            %> <jsp:forward page="controller/report.jsp"></jsp:forward> <%
            break;
        case 14 :
            %> <jsp:forward page="controller/admin.jsp"></jsp:forward> <%
            break;
        case 15 :
            %> <jsp:forward page="controller/issuer.jsp"></jsp:forward> <%
            break;
        default :
            %> <%@include file="views/IndexPage.jsp" %>  <%
            break;
        
    }
%>



