import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/Home")
public class HomeServlet extends HttpServlet {

    private static final long serialVersionUID= 2L;
    String url = "jdbc:derby://localhost:1527//Users/DerbyDbs/ksidb";
    Connection con;


    public void init() throws ServletException {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            con = DriverManager.getConnection(url);
        } catch (Exception exc) {
            throw new ServletException();
        }
    }


    public void serviceRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
    {


        resp.setContentType("text/html; charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.println("<body style=\"background-color:  rgba(109,137,163,0.84)\">");
        out.println("<h2 style =\"color: beige\">Lista dostępnych książek</h2>");
        out.println(" <form method=\"get\"> <br style=\"border-radius: 30px\"> <input style=\"height: 30px; font-size:18px\" type=\"text\" size=\"30\" name=\"szukanie\"> <input type=\"submit\"  style=\"height: 40px; width: 70px; font-size: 40px\" value=\"Search\"> </br></form>");
        out.println(" <form action=\"http://localhost:8080/LibraryServlet/AddNewBook\" <div style=\"text-align: right;  padding-right: 10px\"><input type=\"submit\" style=\"width: 200px; height=100px; font-size: 60px\" value=\"Add new book\"></div>  </form>");

        out.println("<span style=\"height: 30px\">     </span>");



        String sel = "SELECT POZYCJE.WYDID, POZYCJE.AUTID, POZYCJE.tytul, POZYCJE.rok, POZYCJE.cena,  A.name AS Autor, W.name AS Wydawca from POZYCJE\n" +
                "            INNER JOIN AUTOR A on A.AUTID = POZYCJE.AUTID\n" +
                "            INNER JOIN WYDAWCA W on W.WYDID = POZYCJE.WYDID ";

        String search = req.getParameter("szukanie");
        if(search!=null){
            String tmp="LIKE UPPER ('%" + search +"%')";
            sel+="\n";
            sel+="Where  UPPER(Tytul) " + tmp + " OR UPPER(A.Name) " + tmp +  " OR UPPER(W.Name) " + tmp ;
        }

        out.println("<table class=\"sortable\" style=\"align-content: center; margin: auto; border-collapse: separate; border:solid black 1px; border-radius: 7px; background: midnightblue; margin-outside: 30px \"> <thead> \n" +
                "<tr style=\"background-color: midnightblue; color: beige; font-size:20px\">\n" +
                "    <th>Tytuł</th>\n" +
                "    <th>Autor</th>\n" +
                "    <th style=\"width: 100px\">  Cena  </th>\n" +
                "    <th>Wydawnictwo</th>\n" +
                "    <th style=\"width: 200px\">Rok wydania</th>\n" +
                "</tr> </thead>");

        try  {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sel);
            while (rs.next())  {
                out.println(" <tr style=\"background-color: lightsteelblue; font-size: larger; text-align: center\">" + " <td>" + rs.getString("Tytul") + "</td>" + " <td>" + rs.getString("Autor") + "</td>" + " <td>" + rs.getFloat("Cena") + " zł</td>" + " <td>" + rs.getString("Wydawca") + "</td>" + " <td>" + rs.getString("Rok") + "</td> </tr> " );
            }
            out.println("</table>");
            out.println("</body>");
            rs.close();
            stmt.close();
        } catch (SQLException exc)  {
            out.println(exc.getMessage());
        }
        out.close();
    }

    public void destroy() {
        try {
            con.close();
        } catch (Exception exc) {}
    }


    public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException
    {
       serviceRequest(req,resp);
    }


    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        serviceRequest(request,response);

    }
}
