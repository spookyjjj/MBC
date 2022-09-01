package article.command;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import article.dao.ArticleDao;
import article.model.Article;
import article.model.Articles;
import jdbc.connection.ConnectionProvider;

@WebServlet("/getArticle")
public class ArticleSevlet extends HttpServlet {
	private ArticleDao articleDao = new ArticleDao();
	
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	getList(req,resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	getContent(req,resp);
    }

    protected void getList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	System.out.println("게시글리스트보러왔냐");
        req.setCharacterEncoding("utf-8");
        resp.setContentType("application/json;charset=utf-8");
        
        PrintWriter out = resp.getWriter();
        ObjectMapper mapper = new ObjectMapper();
        
        String json = null;
		try (Connection conn = ConnectionProvider.getConnection();) {
			int categoryNum = Integer.valueOf(req.getParameter("categoryNum"));
			int chapterNum = Integer.valueOf(req.getParameter("chapterNum"));
			int storyNumRefresh = Integer.valueOf(req.getParameter("storyNumRefresh"));
			
//			if(req.getParameter("refresh").equals("on")) {
//				storyNumRefresh += 1;
//				System.out.println(categoryNum + "계속 저장될까요?");
//			}
			System.out.println("at servlet 카테고리넘:" + categoryNum + " 챕터넘+리프레쉬넘" + chapterNum + storyNumRefresh);
			Articles result = articleDao.select(conn, categoryNum, chapterNum, storyNumRefresh, req);
			
			if (result.getResult().size() != 0) { //db에서 담아온게 뭐라도 있으면!
				json = mapper.writeValueAsString(result);
			}
			System.out.println("at servlet 게시글 리스트 얻으러왔을때: " + json);
			out.print(json); //아무것도 select된게 없으면 null을 반환함
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }
    
    private void getContent(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	System.out.println("내용 얻으러 왔냐");
    	req.setCharacterEncoding("utf-8");
    	resp.setContentType("application/json;charset=utf-8");
    	
    	PrintWriter out = resp.getWriter();
    	ObjectMapper mapper = new ObjectMapper();
    	ObjectNode node = mapper.createObjectNode();
    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	String json = null;
    	try (Connection conn = ConnectionProvider.getConnection();) {
    		Article article = null;
    		String contentinfo = String.valueOf(req.getParameter("contentinfo"));
    		int storyNumRefresh = Integer.valueOf(req.getParameter("storyNumRefresh"));
    		int chapterNum = Integer.valueOf(req.getParameter("chapterNum"));
    		System.out.println(contentinfo);
    		String[] arr = contentinfo.split("/"); //arr[0]:카테고리넘버, arr[1]:아티클넘버, arr[2]:제목, arr[3]:작성자, arr[4]:작성일, arr[5]:작성시간
    		//아티클넘버가 0이거나 스토리에 해당되는 넘버 이상인경우에는 안보여 줘야함~ 그걸 위한 로직
    		//System.out.println(articleDao.checkStroyNum(conn, arr[0], arr[1], storyNumRefresh));
    		//System.out.println(Integer.valueOf(arr[1]) != 0);
    		//System.out.println(storyNumRefresh);
    		if (articleDao.checkStroyNum(conn, arr[0], arr[1], chapterNum, storyNumRefresh) && Integer.valueOf(arr[1]) != 0) { //참이면 보여줌
	    		String content = "";
	    		if(arr.length == 2) { //길이가 2면 이전글 이후글임
	    			article = articleDao.readBAContent(conn, arr[0], arr[1], req);
	    		} else {
	        		content = articleDao.readArticleContent(conn, arr[0], arr[1]);
	        		article = new Article(Integer.valueOf(arr[0]), Integer.valueOf(arr[1]), arr[3], arr[2], content, arr[4], arr[5]);
	    		}
	    		json = mapper.writeValueAsString(article);
    		}
    		System.out.println("서블릿 내용얻으러왔을때: " + json);
    		out.print(json);
    	} catch (SQLException e) {
			e.printStackTrace();
		}
    }
}