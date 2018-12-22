<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Trang Quản Lý</title>

    <!-- Bootstrap Core CSS -->
    <link href="../vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="../vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- DataTables CSS -->
    <link href="../vendor/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">

    <!-- DataTables Responsive CSS -->
    <link href="../vendor/datatables-responsive/dataTables.responsive.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="../dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="../vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet prefetch"
          href="http://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.3.0/css/datepicker.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style>
        sup {
            vertical-align: middle;
            font-size: x-small;
        }

        #datepicker {
            width: 180px;
            margin: 0 20px 20px 20px;
        }

        #datepicker > span:hover {
            cursor: pointer;
        }
    </style>

</head>

<body>

<c:set value="${sessionScope.USER}" var="user"/>
<div id="wrapper">

    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/room">Trang Quản Lý</a>
        </div>

        <ul class="nav navbar-top-links navbar-right">
            <li class="dropdown open">
                <c:if test="${not empty user && user.roleId eq 1}">
                    <li><a href="/log-out"><i class="fa fa-sign-out fa-fw"></i>Đăng Xuất</a>
                </c:if>
                <c:if test="${empty user && user.roleId ne 1}">
                    <li><a href="/"><i class="fa fa-sign-out fa-fw"></i>Đăng Nhập</a>
                </c:if>
            </li>
            </li>
        </ul>

        <div class="navbar-default sidebar" role="navigation">
            <div class="sidebar-nav navbar-collapse">
                <ul class="nav" id="side-menu">
                    <li>
                        <a href="/users"><i class="fa fa-table fa-fw"></i>Quản lý người dùng</a>
                    </li>
                    <li>
                        <a href="/room"><i class="fa fa-table fa-fw"></i>Danh sách phòng</a>
                    </li>

                </ul>
            </div>
            <!-- /.sidebar-collapse -->
        </div>

    </nav>

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Quản lý người dùng</h1>
            </div>
        </div>
        <div class="row">
            <div class="modal fade" id="adduser" role="dialog">
                <div class="modal-dialog">

                    <!-- Modal content-->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;
                            </button>
                            <h4 class="modal-title">Hình Ảnh Phòng</h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <label>Tên đăng nhập</label>
                                <input id="txtUsername" class="form-control" maxlength="15">
                            </div>
                            <div class="form-group">
                                <label>Mật khẩu</label>
                                <input id="txtPassword" class="form-control" type="password">
                            </div>
                            <div class="form-group">
                                <label>Email</label>
                                <input id="txtEmail" class="form-control" type="email">
                            </div>
                            <div class="form-group">
                                <label>Họ và Tên</label>
                                <input id="txtFullname" class="form-control" maxlength="50">
                            </div>
                            <div class="form-group">
                                <label>Ngày sinh</label>
                                <div id="datepicker" class="input-group date" data-date-format="yyyy-mm-dd">
                                    <input id="dob" class="form-control" readonly="" type="text"> <span
                                        class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Số điện thoại</label>
                                <input id="txtPhone" class="form-control" type="number">
                            </div>
                            <div class="form-group">
                                <label>Giới tính</label>
                                <select id="gender" class="form-control">
                                    <option value="1">Nam</option>
                                    <option value="2">Nữ</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Vai trò</label>
                                <select id="role" class="form-control">
                                    <option value="2">Chủ nhà</option>
                                    <option value="3">Chủ phòng</option>
                                    <option value="4">Thành viên</option>
                                    <option value="5">Quản trị viên</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Ảnh đại diện</label>
                                <input id="txtImage" type="file">
                            </div>
                            <button id="btnAdd" type="submit" class="btn btn-default">Tạo</button>
                            <button type="reset" class="btn btn-default">Xóa dữ liệu</button>
                            <div class="form-group" style="display: none" id="error">
                                <h3 style="color: red">Dữ liệu nhập không đúng</h3>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">
                                Close
                            </button>

                        </div>
                    </div>

                </div>
            </div>
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        Danh sách người dùng
                    </div>
                    <!-- /.panel-heading -->
                    <c:if test="${empty user || user.roleId ne 1}">
                        <div class="col-12">
                            <div class="alert alert-danger text-center">
                                Bạn cần phải đăng nhập
                            </div>
                        </div>

                    </c:if>
                    <c:if test="${not empty user && user.roleId eq 1}">
                        <c:set var="sizes" value="${[10, 20, 50]}"/>
                        <div style="padding: 4px 15px; font-size: 1.5rem;">
                            Hiển thị
                            <select onchange="handleOnChange(${requestScope.CURRENTPAGE}, event.target.value)"
                                    id="page-size">
                                <c:forEach var="size" items="${sizes}">
                                    <c:if test="${requestScope.SIZE eq size}">
                                        <option selected value="${size}">${size}</option>
                                    </c:if>
                                    <c:if test="${requestScope.SIZE ne size}">
                                        <option value="${size}">${size}</option>
                                    </c:if>
                                    <%--<option value="${size}">${size}</option>--%>
                                </c:forEach>
                            </select> người dùng
                        </div>
                        <div style="padding: 6px 15px; font-size: 1.5rem;">
                            <button type="submit" class="btn btn-success" data-toggle="modal"
                                    data-target="#adduser"><span class="glyphicon glyphicon-plus"></span></button>
                        </div>


                        <div class="panel-body">
                            <table width="100%" class="table table-striped table-bordered table-hover"
                                   id="dataTables-example">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên đăng nhập</th>
                                    <th>Họ tên</th>
                                    <th>Ngày sinh</th>
                                    <th>Email</th>
                                    <th>Giới tính</th>
                                    <th>Số điện thoại</th>
                                    <th>Vai trò</th>
                                    <th>Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:set var="userList" value="${requestScope.USERS}"/>
                                <c:set var="ADMIN" value="Admin"/>
                                <c:forEach var="user" items="${userList}">
                                    <tr>
                                        <td>${user.userId}</td>
                                        <td>${user.username}</td>
                                        <td>${user.fullname}</td>
                                        <td>${user.dob}</td>
                                        <td>${user.email}</td>
                                        <td>
                                            <c:if test="${user.gender eq 1}">
                                                Nam
                                            </c:if>
                                            <c:if test="${user.gender eq 2}">
                                                Nữ
                                            </c:if>
                                        </td>
                                        <td>${user.phone}</td>
                                        <td>
                                            <c:if test="${user.roleId eq 1}">
                                                Admin
                                            </c:if>
                                            <c:if test="${user.roleId eq 2}">
                                                Chủ Nhà
                                            </c:if>
                                            <c:if test="${user.roleId eq 3}">
                                                Chủ Phòng
                                            </c:if>
                                            <c:if test="${user.roleId eq 4}">
                                                Thành Viên
                                            </c:if>
                                            <c:if test="${user.roleId eq 5}">
                                                Quản Trị Viên
                                            </c:if>
                                        </td>
                                        <td>
                                            <a href="/users/remove/${user.userId}">
                                                <button type="button" class="btn btn-danger">
                                                    <span class="glyphicon glyphicon-trash"></span>
                                                </button>
                                            </a>
                                        </td>
                                    </tr>

                                </c:forEach>
                                </tbody>
                            </table>

                            <ul class="pagination pagination-lg" style="cursor: pointer">
                                <c:set var="totalPage" value="${requestScope.PAGE}"/>
                                <c:set var="currentPage" value="${requestScope.CURRENTPAGE}"/>

                                    <%--<c:if test="${currentPage eq 1}">--%>
                                    <%--<li><a>Previous</a></li>--%>
                                    <%--<c:forEach var="i" begin="1" end="${totalPage}">--%>
                                    <%--<li onclick="changePage(${i})">--%>
                                    <%--<a>--%>
                                    <%--${i}--%>
                                    <%--</a>--%>
                                    <%--</li>--%>
                                    <%--</c:forEach>--%>
                                    <%--<li onclick="changePage(${currentPage+1})"><a>Next</a></li>--%>
                                    <%--</c:if>--%>

                                <c:if test="${currentPage eq 1 && totalPage ne 1 && totalPage ge 9}">
                                    <li><a>Previous</a></li>
                                    <c:forEach var="i" begin="1" end="9">
                                        <li onclick="changePage(${i})">
                                            <a>
                                                    ${i}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    <li onclick="changePage(${currentPage+1})"><a>Next</a></li>
                                </c:if>

                                <c:if test="${currentPage gt 1 && currentPage le 9}">
                                    <li onclick="changePage(${currentPage - 1})"><a>Previous</a></li>
                                    <c:forEach var="i" begin="1" end="9">
                                        <li onclick="changePage(${i})">
                                            <a>
                                                    ${i}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    <li onclick="changePage(${currentPage + 1})"><a>Next</a></li>
                                </c:if>

                                <c:if test="${currentPage gt 9}">
                                    <li onclick="changePage(${currentPage-1})"><a>Previous</a></li>
                                    <c:forEach var="i" begin="${currentPage}" end="${currentPage + 8}">
                                        <c:if test="${i le totalPage}">
                                            <li onclick="changePage(${i})">
                                                <a>
                                                        ${i}
                                                </a>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                    <li onclick="changePage(${currentPage+1})"><a>Next</a></li>
                                </c:if>

                            </ul>
                        </div>
                    </c:if>

                </div>
            </div>

        </div>
    </div>

</div>

<!-- /#wrapper -->

<!-- jQuery -->
<script src="../vendor/jquery/jquery.min.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="../vendor/bootstrap/js/bootstrap.min.js"></script>

<!-- Metis Menu Plugin JavaScript -->
<script src="../vendor/metisMenu/metisMenu.min.js"></script>

<!-- DataTables JavaScript -->
<%--<script src="../vendor/datatables/js/jquery.dataTables.min.js"></script>--%>
<script src="../vendor/datatables-plugins/dataTables.bootstrap.min.js"></script>
<script src="../vendor/datatables-responsive/dataTables.responsive.js"></script>

<!-- Custom Theme JavaScript -->
<script src="../dist/js/sb-admin-2.js"></script>
<script src="js/jquery-1.11.1.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.3.0/js/bootstrap-datepicker.js"></script>

<!-- Page-Level Demo Scripts - Tables - Use for reference -->
<script>
    $(function () {
        $("#datepicker").datepicker({
            autoclose: true,
            todayHighlight: true
        }).datepicker('update', new Date());
    });
    $(document).ready(function () {
        // $('#dataTables-example').DataTable({
        //     responsive: true
        // });

        $('#btnAdd').click(function (e) {

            e.preventDefault();
            var TbUser = {};
            TbUser["username"] = $('#txtUsername').val();
            TbUser["password"] = $('#txtPassword').val();
            TbUser["email"] = $('#txtEmail').val();
            TbUser["fullname"] = $('#txtFullname').val();
            TbUser["imageProfile"] = $('#txtImage').val();
            TbUser["phone"] = $('#txtPhone').val();
            TbUser["gender"] = $('#gender').val();
            TbUser["roleId"] = $('#role').val();
            TbUser["dob"] = $('#dob').val();

            $.ajax({
                method: "POST",
                contentType: "application/json",
                data: JSON.stringify(TbUser),
                dataType: 'json',
                url: "/user/admin/createUser",
                timeout: 600000,
                success: function (data) {
                    window.location = "/users";
                },
                error: function (e) {
                    document.getElementById("error").style.display = "block";
                    //...
                }
            });

        });
    });

    function handleOnChange(page, size) {
        window.location = "/users?page=" + page + "&size=" + size;
    }

    function changePage(page) {
        var size = document.getElementById("page-size").value;
        window.location = "/users?page=" + page + "&size=" + size;
    }
</script>

</body>

</html>
