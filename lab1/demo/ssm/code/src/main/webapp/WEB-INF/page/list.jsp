<%@ page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path;
%>
<html>
<link rel="stylesheet" href="<%=basePath%>/lib/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=basePath%>/lib/font-awesome.min.css"/>
<head>
    <title>学生信息查看</title>
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
                    <li><a href="<%=basePath%>/student/toListPage.do"><strong>查看学生信息</strong></a></li>
                </ul>
            </div>
        </div>
    </nav>
</div>
<br/>
<%--页面正文--%>
<div class="container">
    <h1 class="text-center">学生信息查看</h1>
    <hr/>
    <hr/>
    <%--学生信息列举--%>
    <div class="table-responsive">
        <table class="table table-hover table-striped">
            <thead>
            <tr>

                <th style="text-align: center;">学生姓名</th>
                <th style="text-align: center;">学生电话</th>
                <th style="text-align: center;">学生学号</th>
                <th style="text-align: center;">学生昵称</th>
                <th style="text-align: center;">操作</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach items="${requestScope.page.beanList}" var="student">
                <tr class="text-center">
                    <td>${student.name}</td>
                    <td>${student.telephone}</td>
                    <td>${student.studentID}</td>
                    <td>${student.nickname}</td>
                    <td>
                        <a href="#" onclick="return edit(${student.id})" style="text-decoration: none;">
                            <span class="fa fa-edit fa-fw"></span>
                        </a>

                        <a href="#" onclick="return trash(${student.id})" style="text-decoration: none"
                           data-toggle="modal" data-target="#trashModal">
                            <span class="fa fa-trash-o fa-fw"></span>
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <%--分页显示控制--%>
    <form class="listForm" method="post"
          action="<%=basePath%>/student/findByPage.do">
        <div class="row">
            <div class="form-inline">
                <label style="font-size: 14px; margin-top:22px;">
                    <strong>共<b>${requestScope.page.totalCount}</b>条记录，共<b>${requestScope.page.totalPage}</b>页</strong>

                    <strong>每页显示</strong>
                    <%--                    <input type="text" size="3" id="pagesize" name="pageSize"
                                               class="form-control input-sm"
                                               style="width:11%"><strong>条</strong>--%>
                    <input name="pageCode" value="${requestScope.page.pageCode}" hidden="hidden"/>
                    <select class="form-control" name="pageSize">
                        <option value="2"
                                <c:if test="${requestScope.page.pageSize==2}">selected</c:if> >2
                        </option>
                        <option value="5"
                                <c:if test="${requestScope.page.pageSize==5}">selected</c:if> >5
                        </option>
                        <option value="10"
                                <c:if test="${requestScope.page.pageSize==10}">selected</c:if> >10
                        </option>
                        <option value="20"
                                <c:if test="${requestScope.page.pageSize==20}">selected</c:if> >20
                        </option>
                    </select>
                    <strong>条</strong>

                    <strong>到第</strong> <input type="text" size="3" id="page" name="pageCode"
                                               class="form-control input-sm"
                                               style="width:11%"><strong>页</strong>
                    <button type="submit" class="btn btn-sm btn-info">GO!</button>
                </label>

                <ul class="pagination" style="float:right;">
                    <li>
                        <a href="<%=basePath%>/student/toSavePage.do?pageCode=1"><strong>首页</strong></a>
                    </li>
                    <li>
                        <c:if test="${requestScope.page.pageCode > 2}">
                            <a href="<%=basePath%>/student/findByPage.do?pageCode=${requestScope.page.pageCode -1}">&laquo;</a>
                        </c:if>
                    </li>

                    <c:choose>
                        <c:when test="${requestScope.page.totalPage <=5}">
                            <c:set var="begin" value="1"/>
                            <c:set var="end" value="${requestScope.page.totalPage}"/>
                        </c:when>

                        <c:otherwise>
                            <c:set var="begin" value="${requestScope.page.pageCode-1}"/>
                            <c:set var="end" value="${requestScope.page.pageCode + 3}"/>

                            <!-- 头溢出 -->
                            <c:if test="${begin < 1}">
                                <c:set var="begin" value="1"/>
                                <c:set var="end" value="5"/>
                            </c:if>

                            <!-- 尾溢出 -->
                            <c:if test="${end > requestScope.page.totalPage}">
                                <c:set var="begin" value="${requestScope.page.totalPage -4}"/>
                                <c:set var="end" value="${requestScope.page.totalPage}"/>
                            </c:if>
                        </c:otherwise>
                    </c:choose>

                    <!-- 显示页码 -->
                    <c:forEach var="i" begin="${begin}" end="${end}">
                        <!-- 判断是否是当前页 -->
                        <c:if test="${i == requestScope.page.pageCode}">
                            <li class="active"><a href="javascript:void(0);">${i}</a></li>
                        </c:if>
                        <c:if test="${i != requestScope.page.pageCode}">
                            <li>
                                <a href="<%=basePath%>/student/findByPage.do?pageCode=${i}&pageSize=${requestScope.page.pageSize}">${i}</a>
                            </li>
                        </c:if>
                    </c:forEach>

                    <li>
                        <c:if test="${requestScope.page.pageCode < requestScope.page.totalPage}">
                            <a href="<%=basePath%>/student/findByPage.do?pageCode=${requestScope.page.pageCode + 1}">&raquo;</a>
                        </c:if>
                    </li>
                    <li>
                        <a href="<%=basePath%>/student/findByPage.do?pageCode=${requestScope.page.totalPage}"><strong>末页</strong></a>
                    </li>
                </ul>
            </div>
        </div>
    </form>


    <%--删除的模态框--%>
    <div class="modal fade" id="trashModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <%--模糊框头部--%>
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" arira-hidden="true">

                    </button>
                    <h4 class="modal-title">警告!</h4>
                </div>
                <%--模糊框主体--%>
                <div class="modal-body">
                    <strong>你确定要删除吗？</strong>
                </div>
                <%--模糊框底部--%>
                <div class="modal-footer">
                    <button type="button" class="delSure btn btn-info" data-dismiss="modal">确定</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 编辑的模态框 -->
    <form class="form-horizontal" role="form" method="post" action="<%=basePath%>/student/update.do"
          id="form_edit">
        <div class="modal fade" id="editModal" role="dialog" aria-labelledby="myModalLabel"
             aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">修改学生信息</h4>
                    </div>
                    <div class="modal-body" style="margin-left: 80px;">
                        <input name="id" id="id" hidden="hidden"/>
                        <div class="form-group form-inline">
                            <label>学生姓名：</label>
                            <input type="text" name="name" class="form-control" id="name"/>
                        </div>
                        <br/>
                        <br/>
                        <div class="form-group form-inline">
                            <label>学生电话：</label>
                            <input type="text" name="telephone" class="form-control" id="telephone"/>
                        </div>
                        <br/>
                        <br/>
                        <div class="form-group form-inline">
                            <label>学生学号：</label>
                            <input type="text" name="studentID" class="form-control" id="studentID"/>
                        </div>
                        <br/>
                        <br/>
                        <div class="form-group form-inline">
                            <label>学生昵称：</label>
                            <input type="text" name="nickname" class="form-control" id="nickname"/>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="editSure btn btn-info" data-dismiss="modal">修改</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                    </div>
                </div>
            </div>
        </div>
    </form>

</div>

</body>
<script src="<%=basePath%>/lib/jquery-3.3.1.min.js"></script>
<script src="<%=basePath%>/lib/bootstrap.min.js"></script>
<script type="text/javascript">
    //删除信息的方法
    function trash(id) {
        if (!id) {
            alert("error!");
        } else {
            $(".delSure").click(function () {
                $.ajax({
                    url: '<%=basePath%>/student/delete.do?id=' + id,
                    type: 'GET',
                    success: function (data) {
                        $("body").html(data);
                    }
                })
            })
        }
    }

    //更新信息的方法
    function edit(id) {
        if (!id) {
            alert("error");
        } else {
            $.ajax({
                url: '<%=basePath%>/student/findById.do',
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json;charset=UTF-8',
                data: JSON.stringify({
                    id: id
                }),
                success: function (data) {
                    $("#id").val(data.id);
                    $("#name").val(data.name);
                    $("#telephone").val(data.telephone);
                    $("#studentID").val(data.studentID);
                    $("#nickname").val(data.nickname);
                    $("#editModal").modal('show');
                },
                error: function () {
                    alert("错误");
                }
            })
        }
    }

    //提交表单
    $(".editSure").click(function () {
        $("#form_edit").submit();
    })
</script>
</html>