<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>검색</title>
</head>
<body>
	<form action="search" method="post"> <!-- 슬러쉬 없이 해야 http://localhost:8080/MBC/search -->
		<input type="text" name="title">
		<input type="submit">
	</form>
	
	<c:if test="${ istrue }"><img alt="이미지" src="${ result.thumbnail }"> </c:if> <br/>
	<c:if test="${ istrue }">${ result.title }</c:if> <br/>
	<c:if test="${ istrue }">${ result.authors }</c:if> <br/>
	<c:if test="${ istrue }">${ result.publisher }</c:if> <br/>
	<c:if test="${ istrue }">${ result.contents } ...중략</c:if>
		
	<c:if test="${ isfalse }">검색결과가 없습니다</c:if>
</body>
</html>