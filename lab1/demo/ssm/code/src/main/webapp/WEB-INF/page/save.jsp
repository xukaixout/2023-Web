<%@ page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path;
%>
<html>
<link rel="stylesheet" href="<%=basePath%>/lib/bootstrap.min.css"/>
<head>
    <title>添加学生信息</title>
</head>
<body>
<!-- 导航栏 -->
<div class="sidebar text-left">
    <nav class="navbar navbar-default" role="navigation">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand">SSM整合</a>
            </div>
            <div>
                <ul class="nav navbar-nav">
                    <li><a href="<%=basePath%>/student/toSavePage.do"><strong>添加学生信息</strong></a></li>
                    <li><a href="<%=basePath%>/student/toListPage.do"><strong>查询学生信息</strong></a></li>
                </ul>
            </div>
        </div>
    </nav>
</div>
<div class="container">
    <h1 class="text-center">学生信息添加页面</h1>
    <hr/>
    <br/>
    <form class="form-inline text-center" action="<%=basePath%>/student/save.do" method="post">
        <div class="form-group form-inline">
            <label>学生姓名：</label>
            <label>
                <input type="text" name="name" class="form-control"/>
            </label>
        </div>
        <br/>
        <br/>
        <div class="form-group form-inline">
            <label>学生电话：</label>
            <label>
                <input type="text" name="telephone" class="form-control"/>
            </label>
        </div>
        <br/>
        <br/>
        <div class="form-group form-inline">
            <label>学生学号：</label>
            <label>
                <input type="text" name="studentID" class="form-control"/>
            </label>
        </div>
        <br/>
        <br/>
        <div class="form-group form-inline">
            <label>学生昵称：</label>
            <label>
                <input type="text" name="nickname" class="form-control"/>
            </label>
        </div>
        <br/>
        <br/>
        <br/>
        <input type="submit" class="btn btn-info text-center"/>
        <input type="reset" class="btn btn-info text-center"/>
    </form>
</div>

</body>
</html>
