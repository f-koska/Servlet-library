<%--
  Created by IntelliJ IDEA.
  User: filipkoska
  Date: 06/06/2021
  Time: 17:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/sql" prefix = "sql" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c"%>

<html>
<head>
    <title>Add New Book</title>
</head>
<body style="background-color:  rgba(109,137,163,0.84)">

<h1 style="text-align: center; color: beige"> Dodaj nową książkę</h1>
<div style="text-align: right; padding-left: 30px"> <form action="http://localhost:8080/LibraryServlet/Home"> <input type="submit" size="200" value="Back" style="height: 150px; width: 150px; font-size: 100px"></form></div>

<sql:setDataSource var = "database" driver = "org.apache.derby.jdbc.ClientDriver"
                   url = "jdbc:derby://localhost:1527//Users/DerbyDbs/ksidb"/>

<sql:query dataSource="${database}" var="Wydawnictwo">
    SELECT * FROM WYDAWCA
</sql:query>

<sql:query dataSource="${database}" var="Autorzy">
    SELECT * FROM AUTOR
</sql:query>

<div style="text-align: center; font-size: medium">

    <form method="post" >
    <label style="margin-right: 55px"> Tytuł</label>
        <input style="height: 30px; width: 260px" type="text" required size="30" name="tytul"/><br>
        <div style="height: 30px">     </div>
     <label style="margin-right: 55px">Autor
    </label>
        <input style="height: 30px; width: 260px" type="text" required size="30" name="aut" list="autor"/>
        <datalist id="autor">
            <c:forEach var="autor" items="${Autorzy.rows}">
                <option value="${autor.name}"></option>
            </c:forEach>
        </datalist><br>
        <div style="height: 30px">     </div>
        <label style="margin-right: 55px"> Cena
    </label>
        <input style="height: 30px; width: 260px"  type="text" required size="30" name="cena"/><br>
        <div style="height: 30px">     </div>
         <label style="margin-right: 15px">Wydawnictwo
    </label>
        <input  style="height: 30px; width: 260px" type="text" required size="30" name="wyd" list="wydawnictwo"/>
        <datalist id="wydawnictwo">
            <c:forEach var="firma" items="${Wydawnictwo.rows}">
                <option value="${firma.name}"></option>
            </c:forEach>
        </datalist><br>
        <div style="height: 30px">     </div>
        <label style="margin-right: 15px"> Rok wydania
    </label>
        <input style="height: 30px; width: 260px" type="text" required size="30" name="rok"/>
        <br>
        <div style="height: 30px">     </div>
        <label style="margin-right: 55px"> ISBN
        </label>
        <input style="height: 30px; width: 260px" type="text" required size="30" name="ISBN"/>
        <br>
        <div style="height: 50px">     </div>
        <input type="submit" value="Add" style="height: 40px; width: 100px; font-size: 40px">
    </form>
</div>
<%
    String autor = request.getParameter("aut");
    String tytul = request.getParameter("tytul");
    String cena = request.getParameter("cena");
    String rok = request.getParameter("rok");
    String isbn = request.getParameter("ISBN");
    String wydawnictwo = request.getParameter("wyd");
    Connection con;
    Statement stmt;
    String url = "jdbc:derby://localhost:1527//Users/DerbyDbs/ksidb";
    try {
        if(autor!=null && tytul!=null && cena!=null && rok!=null && wydawnictwo!=null) {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            con = DriverManager.getConnection(url);
            stmt = con.createStatement();

            String autorzy = "SELECT AUTID FROM AUTOR WHERE NAME='" + autor +"'";
            String wydawcy = "SELECT WYDID FROM WYDAWCA WHERE NAME='" + wydawnictwo +"'";

            String com;
            ResultSet rs1= stmt.executeQuery(autorzy);
            int count=0;
            while (rs1.next()){
                count++;
            }
            if (count<1) {
                com = "INSERT INTO AUTOR(NAME) VALUES('" + autor + "')";
                stmt.executeUpdate(com);
            }
            rs1.close();

            ResultSet rs2=stmt.executeQuery(wydawcy);
            count=0;
            while (rs2.next()){
                count++;
            }
            if (count<1) {
                com = "INSERT INTO WYDAWCA(NAME) VALUES('" + wydawnictwo + "')";
                stmt.executeUpdate(com);
            }
            rs2.close();
            stmt.close();
            stmt=con.createStatement();
            com = "SELECT AUTID FROM AUTOR WHERE NAME='" + autor + "'";
           ResultSet rs3 = stmt.executeQuery(com);
            String idAutor="";
            while (rs3.next()) {
                 idAutor = rs3.getString("AUTID");
            }
            rs3.close();
            com = "SELECT WYDID FROM WYDAWCA WHERE NAME='" + wydawnictwo + "'";
            String idWydawca="";
            ResultSet rs4 = stmt.executeQuery(com);
            while (rs4.next()) {
                idWydawca = rs4.getString("WYDID");
            }
            rs4.close();
            com = "INSERT INTO POZYCJE(ISBN,AUTID,TYTUL,WYDID,ROK,CENA) VALUES('" +isbn+"',"+ idAutor + ", '" + tytul + "', " + idWydawca + "," + rok + "," + cena + ")";
            stmt.executeUpdate(com);
            stmt.close();
        }
    } catch (Exception exc) {
        exc.printStackTrace();
        throw new ServletException();
    }
%>

</body>
</html>
