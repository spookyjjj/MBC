<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>a</title>
</head>
<body>
	<div id="change">
	<p>a</p>
	<button type="button" onclick="sendRequest()" id="button">button</button>
	<a onclick="sendRequest2()">a</a>
	</div>
</body>

<script>
	function sendRequest() {
		var httpRequest = new XMLHttpRequest();
		httpRequest.onreadystatechange = function() {
			if (httpRequest.readyState == XMLHttpRequest.DONE
					&& httpRequest.status == 200) {
				document.getElementById("change").innerHTML = httpRequest.responseText;
			}
		};
		// GET 방식으로 요청을 보내면서 데이터를 동시에 전달함.
		httpRequest.open("GET", "button.jsp", true);
		httpRequest.send();
	}
	function sendRequest2() {
		var httpRequest = new XMLHttpRequest();
		httpRequest.onreadystatechange = function() {
			if (httpRequest.readyState == XMLHttpRequest.DONE
					&& httpRequest.status == 200) {
				document.getElementById("change").innerHTML = httpRequest.responseText;
			}
		};
		// GET 방식으로 요청을 보내면서 데이터를 동시에 전달함.
		httpRequest.open("GET", "alink.jsp", true);
		httpRequest.send();
	}
</script>

</html>