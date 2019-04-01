<%@ page import="java.net.*,java.io.*,java.util.*" %>  
<%
String cls = request.getParameter("class");
if(cls == null) cls="aurora.plugin.poi.usermodel.ExcelParse";
String vl = cls.replace('.','/');
vl += ".class";
ClassLoader loader = this.getClass().getClassLoader() ;
out.println("using classloader "+loader.getClass().getName());
URL file = loader.getResource(vl);
if( file == null) out.println("can't find "+cls);
else out.println(cls + " is from " + file.getFile());
%>