<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<div id="box" style="border: 3px solid #333333; border-radius: 20px; overflow: hidden; width: 500px; height: 500px;">
	</div>

	<button id="requestBtn1">a!</button>
	<button id="requestBtn2">b!</button>
	<p id="out"></p>
</body>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
	$(function() {
		$("#requestBtn1").on("click", function() {
			$("#box").load("a.jsp", function() {
				$("#button").on("click", function(e) {
					$('#out').text("안녕하세요!");
					
				});
			});
		});
	});
	$(function() {
		$("#requestBtn2").on("click", function() {
			$("#box").load("b.jsp");
		});
	});
	
</script>

</html>