<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Rubik+Dirt&display=swap"
	rel="stylesheet">
<meta charset="UTF-8">
<!-- String auth_user = request.getSession().getAttribute("user_name");
String auth_leftnum = request.getSession().getAttribute("stroy_num").split("_")[0]; 
원래 로그인할 때 세션에 담아서 와야하지만 지금은 걍 임의설정해줌
 story_num이 2_1이러면, 왼쪽 분리해서 저장-->
<% 
String auth_user = "playername";
String auth_leftnum = "2";
%>
<title>게시판</title>
<style>
body {
	background-color: #F8F8FF;
}

.headerBox {
	margin: 50px 0 0 80px;
	width: 1200px;
	height: 40px;
	background-color: #a7c9f3;
	border: 0.4px solid #464964;
	border-bottom: none;
	border-radius: 5px 5px 0 0;
}

.headerBox button {
	margin: 6px 0 0 3px;
	width: 30px;
	height: 30px;
	background-color: #a7c9f3;
	border: 0px;
	border-radius: 16px;
}

.headerBox button:hover {
	background-color: #cee2fc;
}

.headerBox i {
	border-radius: 0 0 5px 5px;
	font-size: 20px;
	color: #fff;
}

section {
	margin: 0 0 0 80px;
	width: 1200px;
	height: 800px;
	border: 0.4px solid #464964;
	background-color: #fff;
}

.sectionBox {
	margin: 0 0 0 60px;
	float: left;
	width: 850px;
}

.sectionBox h1 {
	margin: 55px 0 0 0;
	border: 0;
	color: #464964;
}

.sectionBox hr {
	margin: 5px 80px 0 0;
	border-color: #464964;
}

.main {
	text-align: center;
}

.tab {
	margin: 45px 25px 0 0;
	float: left;
	width: 200px;
	height: 800px;
	text-align: center;
	line-height: 30px;
}

.tab>hr {
	width: 230px;
	height: 0.5px;
	border: 0.2px solid #b0c4de;
}

.tab a {
	color: #464964;
	padding: 0 0 0 15px;
}

.tab a:link {
	color: #464964;
	text-decoration-line: none;
}

.tab form {
	padding: 0 0 0 25px;
}

.tab input[type="text"]:focus {
	border: 2px solid #add8e6;
	border-radius: 3px;
	outline: none;
}

#bookResult {
	width: 230px;
	height: 410px;
	margin: 15px 0 0 0;
	font-size: 12px;
	line-height: 1.4;
}

#searchStart {
	margin: 3 0 0 0px;
	width: 30px;
	height: 25px;
	background-color: #add8e6;
	border: 0px;
	border-radius: 3px;
}

#searchStart:hover {
	background-color: #d3f1fc;
	color: #fff;
}

.bookTop {
	display: flex;
	width: 230px;
	height: 130px;
}

.bookTop img {
	margin: 15px 5px 5px 3px;
	width: 100px;
	height: 120px;
}

.bookTopText p {
	margin: 4px 0 0 0;
	vertical-align: top;
}

.bookTopText p:first-child {
	margin: 23px 0 0 0;
	font-weight: bolder;
}

.bookTopText p:nth-child(4) {
	color: #85A0C2;
	font-weight: bolder;
}

.buttom p:last-child {
	height: 280px;
	text-overflow: ellipsis;
	line-height: 1.8;
	text-align: left;
}

.timer {
	position: absolute;
	left: 1300px;
	top: -15px;
	width: 300px;
	height: 70px;
	font-size: 50px;
	text-align: center;
	width: 300px;
}

.onoff {
	position: absolute;
	left: 100px;
	top: 0px;
	width: 100px;
	height: 23px;
	text-align: center;
}
</style>
</head>
<script type="text/javascript">
	/* setInterval(() => {
		refreshOnOff();
	}, 2000);
	function refreshOnOff() {
		if ($("#refreshBtn").attr("disabled") == null) { //비활성화상태
			$("#refreshBtn").removeAttr("disabled");
			
		} else {
			
		}
	} */
</script>
<header>
<input type="hidden" id="auth_user" value="<%= auth_user %>">
<input type="hidden" id="auth_leftnum" value="<%= auth_leftnum %>">
	<div class="headerBox">
		<button id="refreshBtn" onclick="refreshStroy()">
		<!-- <button class="loadArticleBtn refresh" type="0"> -->
			<i class="xi-redo icon"></i>
		</button>
	</div>
</header>
<body>
	<section>
		<div class="sectionBox" id="box">
			<div class="main">
				<!-- 첫화면 메인페이지 내용..사진같은거 넣어서 꾸미면 될 듯-->
				<h2>Mystery Book Club</h2>
			</div>
		</div>
		<div class="tab">
			<div>
				<a href="#">내 글 보기</a>
			</div>
			<hr>
			<div>
				<a href="#" id="noticeBtn" class="loadArticleBtn" type="2">공지사항</a>
				<%-- <a onclick='showcontent(this)' type="2/<%= auth_leftnum  %>/공지제목뭔데몰라불러와/revenger/현재날짜/현재시간" href='#'>공지사항</a> --%>
			</div>
			<hr>
			<div>
				<a href="#" id="weekBtn" class="loadArticleBtn" type="3">주간도서</a>
			</div>
			<div>
				<a href="#" id="helloBtn" class="loadArticleBtn" type="4">가입인사</a>
			</div>
			<div>
				<a href="#" id="freeBtn" class="loadArticleBtn" type="5">자유게시판</a>
			</div>
			<div>
				<a href="#" id="meetBtn" class="loadArticleBtn" type="6">우리 모여요!</a>
			</div>
			<hr>
			<!-- <form action="#"> -->
			<input id="searchBook" type="text" placeholder="도서 검색"
				style="width: 110px; height: 19px;" />
			<button id="searchStart" type="submit">
				<i class="xi-search"></i>
			</button>
			<!-- </form> -->
			<div id="bookResult"></div>
			<div id="bookContent"></div>
		</div>
	</section>

	<!-- 타이머 -->
	<p class="timer" id="timers">긴급한 타이머 구동전</p>
	<input type="button" id="start" value="타이머 시작" />
	<!-- BGM ON,OFF -->
	<p class="onoff">
		BGM <input type="button" id="onoff" value="OFF" disabled="disabled" />
	</p>
</body>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
	//필드값처럼..변수선언해놓음
	var userName = $("#auth_user").val();
	var chapterNum = $("#auth_leftnum").val(); //임의설정 <- user정보에 있는거 넘겨받으면 됨!
	var storyNumRefresh = 1; //처음엔 무조건 X-1부터 시작하게끔~!
	var categoryNum = 0;
	/* var refresh = null; */
	document.cookie = chapterNum + '_1=' + dateTrim() + ';expires=3600;path=/';
	
	function dateTrim() {
		const date = new Date();
		const year = date.getFullYear();
		const month = ('0' + (date.getMonth() + 1)).slice(-2);
		const day = ('0' + date.getDate()).slice(-2);
		const hours = ('0' + date.getHours()).slice(-2);
		const minutes = ('0' + date.getMinutes()).slice(-2);
		const seconds = ('0' + date.getSeconds()).slice(-2);
		const dateStr = year + '.' + month + '.' + day + 'T' + hours + ':' + minutes + ':' + seconds;
		return dateStr
	}
	
	function refreshStroy() {
		//새로고침 누르면 storyNumRefresh(storyRight) 수 늘리고 그 때의 시간 쿠키에 담기
		storyNumRefresh ++;
		document.cookie = chapterNum + '_' + storyNumRefresh + '=' + dateTrim() + ';expires=7200;path=/';
		$("#box").load("free_article.jsp", function() {
			if(categoryNum !== 0) {
			loadArticle(categoryNum); //loadArticle함수에는 카테고리넘버만 넘겨준다!!!
			}
		});
	}
	
	//게시글 하나하나에다가 onclick으로 showcontent(e)걸어둠
	function showcontent(e) {
		//console.log($(e).attr("type"));
		$.ajax({
			url : "/MysteryBookClub/getArticle", // 클라이언트가 요청을 보낼 서버의 URL 주소
			type : "POST", // HTTP 요청 방식(GET, POST)
			data: {"contentinfo":$(e).attr("type"),
					"chapterNum":chapterNum,
					"storyNumRefresh":storyNumRefresh},
			dataType : "json"
		}).done(function(data) {
			console.log(data);
			if (data == null) {
				alert("조회할 글이 없습니다.");
			} else {
			$("#contentBox").load("content.jsp", data, function() { //페이지로드 된 다음에야~~ .listBtn을 찾음!
				if (data.category == 2) { //공지글이면 타이틀이름 변경필요
					$(".titleName").html("<h1 id='titleh1'>공지사항</h1>");
				}
			}); 
		}
		}).fail(function() {
			alert("요청 실패");
		}); 
	}
	function goList(cateNum) {
		$("#box").load("free_article.jsp", function() {
			loadArticle(cateNum); //loadArticle함수에는 카테고리넘버만 넘겨준다!!!
		});
	}
		//게시판간 이동 & 게시글 불러오기
		$(".loadArticleBtn").on("click", function() { //게시판가는 버튼마다 type값으로 categoryNum지정해놓은거 가공
			categoryNum = $(this).attr("type"); 
			if (categoryNum !== "0") { //게시판 눌렀을때
				/* refresh = "off"; */
			} 
			$("#box").load("free_article.jsp", function() {
			loadArticle(categoryNum); //loadArticle함수에는 카테고리넘버만 넘겨준다!!!
			});
		});
		//loadArticle : 게시글 불러오는 함수
		function loadArticle(cateNum) { 
			//누른 카테고리넘버에 맞게 제목설정
			var title = "<h1 id='titleh1'>";
			if(cateNum === "1") {
				title += "내 글 보기";
			} else if (cateNum === "2") {
				title += "공지사항";
			} else if (cateNum === "3") {
				title += "주간 도서";
			} else if (cateNum === "4") {
				title += "가입 인사";
			} else if (cateNum === "5") {
				title += "자유 게시판";
			} else if (cateNum === "6") {
				title += "우리 모여요!";
			}
			title += "</h1>";
			$(".titleName").html(title);
			//console.log(title);
			
			//리스트 불러오기
			 $.ajax({ 
					url : "/MysteryBookClub/getArticle", // 클라이언트가 요청을 보낼 서버의 URL 주소
					type : "GET", // HTTP 요청 방식(GET, POST)
					data: {"categoryNum":cateNum,
							"chapterNum":chapterNum,
							"storyNumRefresh":storyNumRefresh,
							/* "refresh":refresh */
							},
					dataType : "json" // 서버에서 보내줄 데이터의 타입 
				}).done(function(json) {
					//let jsonObj = JSON.parse(json);
					//console.log(document.getElementById("articleList").innerHTML);
					 if (json != null) {
						 //한줄은 공지
						var empLine = "<p>공지</p><a onclick='showcontent(this)' type='" + json.result[0].category 
						+ "/" + json.result[0].article_no + "/" + json.result[0].title
						+ "/"+ json.result[0].user_name + "/" + json.result[0].record_date 
						+ "/" + json.result[0].record_time + "' href='#' class='content'>" 
						+ json.result[0].title + "</a><p>"
							+ json.result[0].user_name + "</p><p>" + json.result[0].record_date + "</p>";
						$(".emphasis").html(empLine);
						
						//나머지줄은 해당 게시글
						var line = "";
						var blankSize = 11 - json.result.length; //한페이지 게시글 11개 기준으로 설정함
						for (var k = 1; k < json.result.length; k++) {
							line += "<tr><td>" + json.result[k].article_no
						    + "</td><td><a onclick='showcontent(this)' type='" + json.result[k].category + "/" 
						    + json.result[k].article_no + "/" + json.result[k].title
						    + "/"+ json.result[k].user_name + "/" +json.result[k].record_date 
						    + "/" + json.result[k].record_time + "' href='#' class='content'>" 
						    + json.result[k].title 
						    + "</a></td><td>" + json.result[k].user_name 
						    + "</td><td>" + json.result[k].record_date + "</td></tr>";
						}
						//빈줄출력
						for (var i = 0; i < blankSize; i++) {
							line += "<div class='emptyRow'><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr></div>";
						}
						//페이징처리
						var line2 = "<c:if test='${ articlePage.startPage > 5 }'>"
							+ "<a href='list.do?pageNo=${ articlePage.startPage - 5 }' class='before'>이전</a></c:if>"
							+ "<c:forEach var='pNo' begin='${ articlePage.startPage }' end='${ articlePage.endPage }'>"
							+ "<c:if test='${ articlePage.hasArticles() }'><a href='list.do?pageNo=${ pNo }'> [${ pNo }] </a></c:if>"
							+ "</c:forEach>"
						 	+ "<c:if test='${ articlePage.endPage < articlePage.totalPages }'>"
							+ "<a href='list.do?pageNo=${ articlePage.startPage + 5 }' class='after'>다음</a></c:if>";
						$("#articleList").html(line);
						$(".pagebtn").html(line2); //게시글 11개 이하일때 조건 줘야함
					} else { //이건 게시물 하나도 없을때.. 나중에 db채우고 나면 지워도됨
						var line = "";
						for (var i = 0; i < 11; i++) {
							line += "<div class='emptyRow'><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr></div>";
						}
						$("#articleList").html(line);
						$(".pagebtn").html("<p>&nbsp;</p>");
					}
				 }).fail(function() {
					alert("요청 실패");
				}); 
		}
		//영빈 - 새로고침 ajax
		
		//효정 - 책검색하기위한 코드
		$("#searchStart").on("click", function() {
			var searchBook = $("#searchBook").val();
			$.ajax({
				url : "/MysteryBookClub/search", // 클라이언트가 요청을 보낼 서버의 URL 주소
				type : "POST", // HTTP 요청 방식(GET, POST)
				data: {"title":searchBook},   
				dataType : "json" // 서버에서 보내줄 데이터의 타입 
			}).done(function(json) {	
				//console.log(json.documents[0]);
				if (json.documents[0] != null) {
					const isbnArr = json.documents[0].isbn.split(" ");
					var tag = "<div class='bookTop'><img src=" + json.documents[0].thumbnail + "><div class='bookTopText'><p>";
					tag += json.documents[0].title + "</p><p>";
					tag += json.documents[0].authors + "</p><p>";
					tag += json.documents[0].publisher + "</p><p>isbn : ";
					tag += isbnArr[0] + "</p></div></div><div class='buttom'><p>"; // isbn 10자리는 인덱스 [0] 13자리는 [1]
					tag += json.documents[0].contents + "...(중략)</p></div>";
				} else {
					var tag = "<div class='bookTopText'><p>검색결과가 없습니다</p></div>";	
				}
				$("#bookResult").html(tag);
			}).fail(function() {
				alert("검색어를 입력하세요");
			});
		});
	

//	대수 - 타이머 스크립트
	let start = document.getElementById("start"); // 타이머 시작 이벤트 가져옴
	let bgmOnOff = document.getElementById("onoff"); // BGM ON OFF 버튼

	let sec = 600;
	let time = sec;

	/* const bgm = new Audio();
	bgm.src = "./BGM/smooth-waters.mp3"; */

// 	타이머 실행 명령어
	start.addEventListener("click", function (e) {
		e.preventDefault;
		e.stopPropagation;
		if (time != sec) {
			return; // 첫 클릭에서만 타이머 실행
		}
		bgm.play();
		bgm.loop = true;
		bgmOnOff.removeAttribute("disabled"); // BGM 버튼 비활성화
		
		var interval = setInterval(() => {
			let h = parseInt(time / 60).toString();
			let m = (time % 60).toString();
			let timer = document.getElementById("timers");
			
			if (h.length < 2) {
				h = "0"+h;
			}
			if (m.length < 2) {
				m = "0"+m;
			};
			
			let timeover = h + " : " + m;
			if (time < 0) {
				bgm.pause();
				bgm.currentTime = 0;
				bgmOnOff.setAttribute("disabled", "disabled");
				
				timer.innerHTML = "TIME OVER!";
				time = sec;
				bgmOnOff.value = "OFF";
				clearInterval(interval); // 시간종료가 되면 종료됨, 멈춘상태에서 다시 누를경우 재실행
				return;
			} else {
				timer.innerHTML = timeover;
			}
			time--;
		}, 1000);
	});
	
	
	bgmOnOff.onclick = function() {
		let onoff = bgmOnOff.value;
		
		if (onoff === "OFF") {
			bgmOnOff.value = "ON";
			bgm.pause();
		} else {
			bgmOnOff.value = "OFF";
			bgm.play();
		}
	}
// 	여기까지 타이머

</script>
</html>