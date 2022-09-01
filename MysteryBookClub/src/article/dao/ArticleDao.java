package article.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.Arrays;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import article.model.Article;
import article.model.Articles;
import jdbc.JdbcUtil;

public class ArticleDao {

	//지정범위의 게시글을 읽어오기 위한 select메소드
		public Articles select(Connection conn, int categoryNum, int storyNum, int storyNumRefresh, HttpServletRequest req) throws SQLException {
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String emplistquery = "SELECT * FROM mbc.article WHERE article_id LIKE '02%' and story_num like '" + storyNum + "%' ORDER BY article_id DESC limit 1";
			String articlelistquery = "SELECT * FROM mbc.article WHERE article_id LIKE '0" + categoryNum 
						+ "%' ORDER BY article_id DESC;";
			try {
				Articles articles = new Articles();
				
				// 공지 글 추가
				pstmt = conn.prepareStatement(emplistquery);
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					articles.getResult().add(converter(rs, req));
				}
				JdbcUtil.close(rs);
				JdbcUtil.close(pstmt);
				
				// 게시글 추가
				pstmt = conn.prepareStatement(articlelistquery);
				rs = pstmt.executeQuery();
				while (rs.next()) {
//					if (storyNum == 1) {
//						articles.getResult().add(converter(rs, req));
//					} else {
						int storyNumLeft = Integer.valueOf(rs.getString("story_num").split("_")[0]);
						int storyNumRight = Integer.valueOf(rs.getString("story_num").split("_")[1]);
						
						if (storyNumLeft <= storyNum && storyNumRight <= storyNumRefresh) {
							articles.getResult().add(converter(rs, req));
						}
//					}
				}
				return articles;
			} finally {
				JdbcUtil.close(rs);
				JdbcUtil.close(pstmt);
			}
		}
		
		public String readArticleContent(Connection conn, String categoryNum, String articleNumS) throws SQLException {
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String query = "SELECT content FROM mbc.article WHERE article_id = ?";
			
			try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, articleIdSum(categoryNum, articleNumS));
				rs = pstmt.executeQuery();
				String s = null;
				if (rs.next()) {
					s = rs.getString(1);
				}
				return s;
			} finally {
				JdbcUtil.close(rs);
				JdbcUtil.close(pstmt);
			}
		}
		
		public Article readBAContent(Connection conn, String categoryNum, String articleNumS, HttpServletRequest req) throws SQLException {
			
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			Article article = null;
			String query = "SELECT * FROM mbc.article WHERE article_id = ?";
			
			try {
				pstmt = conn.prepareStatement(query);
				//System.out.println(articleIdSum(categoryNum, articleNumS));
				pstmt.setString(1, articleIdSum(categoryNum, articleNumS));
				rs = pstmt.executeQuery();
				
				if (rs.next()) {
					article = converter(rs, req); //내용비워둔 article들고왔다가
					article.setContent(rs.getString("content")); //내용채움
				}
				//System.out.println(article);
				return article;
			} finally {
				JdbcUtil.close(rs);
				JdbcUtil.close(pstmt);
			}
		}
		
		// 아티클 아이디 자동합성
		public String articleIdSum(String categoryNum, String articleNumS) {
			String articleId = "0" + categoryNum + "_";
			
			int articleNum = Integer.valueOf(articleNumS);
			if(articleNum / 100 >= 1) {
				articleId += articleNum;
			} else if (articleNum / 10 >= 1) {
				articleId += "0" + articleNum;
			} else {
				articleId += "00" + articleNum;
			}
			
			return articleId;
		}
		
		// 최신공지 읽어오기
//		public String readEmpContent(Connection conn, String storyNum) throws SQLException {
//			PreparedStatement pstmt = null;
//			ResultSet rs = null;
//			
//			String query = "SELECT content FROM mbc.notice WHERE notice_no = ?";
//			try {
//				pstmt = conn.prepareStatement(query);
//				pstmt.setString(1, storyNum);
//				rs = pstmt.executeQuery();
//				String s = null;
//				if (rs.next()) {
//					s = rs.getString(1);
//				}
//				return s;
//			} finally {
//				JdbcUtil.close(rs);
//				JdbcUtil.close(pstmt);
//			}
//		}

		private Article converter(ResultSet rs, HttpServletRequest req) throws SQLException {
			String date = "";
			String time = "";
			if (rs.getString("record_time").equals("0")) { //여기서 현재시간 세팅하기
				Cookie[] cookies = req.getCookies();
				if(cookies!=null){
		            for (Cookie c : cookies) {
		                String name = c.getName(); // 쿠키 이름 가져오기
		                String value = c.getValue(); // 쿠키 값 가져오기
		                if (name.equals(rs.getString("story_num"))) {
		                	date = value.split("T")[0];
		                	time = value.split("T")[1];
		                }
		           }
				}
			} else {
				date = articleRecordDate(rs.getString("record_time"))[0];
				time = articleRecordDate(rs.getString("record_time"))[1];
			}
			 Article a = new Article(categotyNumSplit(rs.getString("article_id")),
					articleNumSplit(rs.getString("article_id")),
					rs.getString("user_name"),
					rs.getString("title"),
					date,
					time);
			 return a;
		}
		
		public int articleNumSplit(String article_id) {
			String[] arr = article_id.split("_");
			int articleNum = Integer.valueOf(arr[1]);
			return articleNum;
		}
		public int categotyNumSplit(String article_id) {
			String[] arr = article_id.split("_");
			int categotyNum = Integer.valueOf(arr[0]);
			//System.out.println(categotyNum);
			return categotyNum;
		}
		
		//레코드 타임도 현재날짜에서 - 년, 월, 일 한 값은 집어넣는 가공절차
		public String[] articleRecordDate(String record_time) {
			String[] splitArr = record_time.split("_");
			int[ ] intArr = Arrays.stream(splitArr).mapToInt(Integer::parseInt).toArray();
			
			LocalDateTime recordDateTime 
					= LocalDateTime.now().minusYears(intArr[0])
					.minusMonths(intArr[1])
					.minusDays(intArr[2])
					.minusHours(intArr[3])
					.minusMinutes(intArr[4]);
			
			String[] timeArr = String.valueOf(recordDateTime).replace("-", ".").split("T");
			
			return timeArr;
		}
		
		// 전체 글 수 카운트 -> 페이지 계산
		public int selectCount(Connection conn,  int categoryNum, int storyNum) throws SQLException {
			Statement stmt = null;
			ResultSet rs = null;
			try {
				stmt = conn.createStatement();
				rs = stmt.executeQuery("select count(*) from article WHERE article_id LIKE '0" + categoryNum
										+ "%' AND story_num LIKE '" + storyNum + "%'");
				if(rs.next()) {
					return rs.getInt(1);
				}
				
				return 0;
			} finally {
				JdbcUtil.close(rs);
				JdbcUtil.close(stmt);
			}
		}
		//탭부분의 공지사항누르면 공지글로 할때 제목 불러오는 역할
//		public String getEmpTitle(Connection conn, String notice_no) throws SQLException {
//			PreparedStatement pstmt = null;
//			ResultSet rs = null;
//			try {
//				pstmt = conn.prepareStatement("SELECT title FROM mbc.notice WHERE notice_no = ?");
//				pstmt.setString(1, notice_no);
//				rs = pstmt.executeQuery();
//				if(rs.next()) {
//					return rs.getString(1);
//				}
//				return "";
//			} finally {
//				JdbcUtil.close(rs);
//				JdbcUtil.close(pstmt);
//			}
//		}

		public boolean checkStroyNum(Connection conn, String categoryNum, String articleNumS, int chapterNum, int storyNumRefresh) throws SQLException {
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String query = "SELECT story_num FROM mbc.article WHERE article_id = ?";
			
			try {
				pstmt = conn.prepareStatement(query);
				//System.out.println(articleIdSum(categoryNum, articleNumS));
				pstmt.setString(1, articleIdSum(categoryNum, articleNumS));
				rs = pstmt.executeQuery();
				int storyleft = 1;
				int storyright = 1;
				if (rs.next()) {
					storyleft = categotyNumSplit(rs.getString("story_num")); //걍 3_5이면 3를 배출하는 로직
					storyright = articleNumSplit(rs.getString("story_num")); //걍 3_5이면 5를 배출하는 로직
				}
				return storyleft <= chapterNum && storyright <= storyNumRefresh ; //article넘버로 검색한 story_num의 오른쪽과 메인페이지에 저장된 story_num의 오른쪽비교~
			} finally {
				JdbcUtil.close(rs);
				JdbcUtil.close(pstmt);
			}
			
		}
}