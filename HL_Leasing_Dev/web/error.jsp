<%@ page contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<%@ page import="java.io.*" %>
<%@ page import="org.slf4j.MDC" %>
<html>
<body>
<h2>网络异常，请重试或联系管理员</h2>
<%
	out.println("日志路径: " + MDC.get("logFile"));
%>
</body>
</html>