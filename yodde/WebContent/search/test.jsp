<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<c:set var="root" value="${pageContext.request.contextPath}"/>
	<script type="text/javascript" src="${root}/js/jquery.js"></script>
</head>
	<script>
		var params = {"target" : "local", "query" : "", "display":5} // OpenAPI 요청변수 정의
		function callOpenAPI() {
			params.query = encodeURIComponent($("#query").val());
			var q = $.param(params);
			var ajax_url = "proxy.do?" + q; // OpenAPI 요청 URL 구성
			$.ajax({ type: "get", url: ajax_url,
				contentType: "text/xml; charset=utf-8", dataType: "xml",
				error: function(xhr, status, error) { alert("error : " +status); },
				success: showResult }); // Ajax 호출 및 이벤트 핸들러 함수 정의
		}
		function showResult(xml) {// Ajax 호출 성공시 실행되는 함수
			var totalCount = $(xml).find("total").text(); // <total>값 추출
			$("#result").text(totalCount + "건 검색"); // <total>값 표시
			$(xml).find("rss").find("channel").find("item").each(function(idx) {
				var title = $(this).find("title").text(); // <title>값 추출
				var category = $(this).find("category").text();
				var telephone = $(this).find("telephone").text();
				var address = $(this).find("address").text();
				var roadAddress = $(this).find("roadAddress").text();
				var mapx = $(this).find("mapx").text();
				var mapy = $(this).find("mapy").text();
				var item = "title="+ title + "&category="+ category + "&telephone=" + telephone + "&address=" + address + "&roadAddress=" + roadAddress + "&mapx=" + mapx + "&mapy=" + mapy;
				$("#result").append("<br/>" + "<a href='javascript:insertStore(\""+item+"\")'>"+ title + "</a>"); // <title>값 표시
				//$("#result").append("<br/>" + category); // <category>값 표시
			});
		}
		function insertStore(item){			
			//alert(item);			
			$.ajax({
				url:"checkStore.do",
				type:"post",
				data:item,
				contentType:"application/x-www-form-urlencoded;charset=utf-8",
				dataType:"text",
				success:function(data){
					$("#resultDisplay").html(data);					
				},
				error:function(xhr, status, error){
					var array=new Array();
					array.push("xhr:" + xhr);
					array.push("status:" + status);
					array.push("error:" + error);
					alert(array);
				}
			});		   		
		}
	</script>
<body>
	<input type="text" id="query" />
	<input type="button" onclick="callOpenAPI()" value="search"/>
	<div id="result"></div>
	<div id="resultDisplay"></div>
</body>
</html>