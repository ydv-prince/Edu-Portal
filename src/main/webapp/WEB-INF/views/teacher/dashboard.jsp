<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> 

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instructor Portal | E-Learn</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-dark: #090e1a;
            --surface: #111827;
            --primary: #4e73df;
            --text-main: #f8fafc;
            --text-dim: #94a3b8;
            --danger: #ef4444;
        }

        body { background-color: var(--bg-dark); color: var(--text-main); font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }

        .portal-nav { background: rgba(9, 14, 26, 0.8); backdrop-filter: blur(10px); padding: 15px 40px; border-bottom: 1px solid rgba(255,255,255,0.05); position: sticky; top: 0; z-index: 1000; }
        .sidebar { background: var(--surface); border-radius: 24px; padding: 24px; height: fit-content; border: 1px solid rgba(255,255,255,0.05); }
        
        .nav-item-link {
            display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px;
            color: var(--text-dim); text-decoration: none; transition: 0.3s; margin-top: 8px;
        }
        .nav-item-link:hover, .nav-item-link.active { background: rgba(78, 115, 223, 0.1); color: var(--primary); }
        .nav-item-link.logout { color: var(--danger); margin-top: 30px; }

        .welcome-banner { background: linear-gradient(90deg, #4e73df 0%, #3b82f6 100%); border-radius: 24px; padding: 40px; position: relative; overflow: hidden; }
        .stat-card { background: var(--surface); border: 1px solid rgba(255,255,255,0.05); border-radius: 20px; padding: 24px; transition: 0.3s; height: 100%; }
        .stat-card:hover { transform: translateY(-5px); border-color: var(--primary); }
        
        .btn-create { background: var(--primary); color: white; border: none; padding: 10px 24px; border-radius: 12px; font-weight: 700; text-decoration: none; display: inline-block; transition: 0.3s; }
        .btn-create:hover { background: #3b5bdb; color: white; transform: scale(1.05); }
        
        /* Profile Icon Pointer */
        .profile-trigger { cursor: pointer; transition: 0.3s; }
        .profile-trigger:hover { transform: scale(1.1); }
    </style>
</head>
<body>

<nav class="portal-nav d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center gap-2">
        <div class="bg-primary p-2 rounded-3 text-white"><i class="fa-solid fa-graduation-cap"></i></div>
        <h4 class="m-0 fw-bold">E-Learn</h4>
    </div>
    <div class="d-flex align-items-center gap-4">
        <%-- Top Profile Icon Link (Added null safety for Name) --%>
        <div class="bg-warning rounded-circle text-dark fw-bold d-flex align-items-center justify-content-center profile-trigger" 
             style="width:35px; height:35px" 
             onclick="location.href='${pageContext.request.contextPath}/teacher/profile'">
            <c:choose>
                <c:when test="${not empty teacher.fullName}">
                    <c:out value="${teacher.fullName.substring(0,1).toUpperCase()}" />
                </c:when>
                <c:otherwise>T</c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<div class="container-fluid px-lg-5 px-3">
    <div class="row g-4 mt-2">
        <div class="col-lg-3">
            <div class="sidebar shadow-sm">
                <div class="portal-label mb-3" style="font-size:0.65rem; color:var(--text-dim); font-weight:800;">MENU</div>
                <a href="${pageContext.request.contextPath}/teacher/dashboard" class="nav-item-link active"><i class="fa-solid fa-house"></i> Overview</a>
                <a href="${pageContext.request.contextPath}/teacher/courses" class="nav-item-link"><i class="fa-solid fa-book-open"></i> My Courses</a>
                
                <%-- Added Assessment Center Link --%>
                <a href="${pageContext.request.contextPath}/teacher/assignments" class="nav-item-link"><i class="fa-solid fa-file-signature"></i> Assessments</a>
                
                <%-- Updated Student List Link to match your folder structure --%>
                <a href="${pageContext.request.contextPath}/teacher/courses/students" class="nav-item-link"><i class="fa-solid fa-users"></i> Student List</a>
                
                <%-- Updated Revenue Link to match your folder structure --%>
                <a href="${pageContext.request.contextPath}/teacher/revenue" class="nav-item-link"><i class="fa-solid fa-chart-line"></i> Analytics</a>
                
                <a href="${pageContext.request.contextPath}/teacher/profile" class="nav-item-link"><i class="fa-solid fa-user-circle"></i> My Profile</a>
                
<a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link logout">
    <i class="fa-solid fa-right-from-bracket"></i> Sign Out
</a>             
            </div>
        </div>

        <div class="col-lg-9">
            <div class="welcome-banner mb-4 shadow">
                <div class="d-flex align-items-center gap-3">
                    <div class="bg-white bg-opacity-20 p-3 rounded-4"><i class="fa-solid fa-briefcase fa-xl text-white"></i></div>
                    <div>
                        <h2 class="fw-bold m-0 text-white">Welcome Back, <c:out value="${teacher.fullName}" default="Instructor"/>! 👋</h2>
                        <p class="m-0 text-white opacity-75">Ready to manage your courses and students?</p>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="stat-lbl text-dim small fw-bold">ACTIVE COURSES</div>
                                <div class="stat-num h2 fw-800 mt-2"><c:out value="${totalCourses}" default="0"/></div>
                            </div>
                            <i class="fa-solid fa-layer-group text-primary fs-4 opacity-50"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="stat-lbl text-dim small fw-bold">TOTAL STUDENTS</div>
                                <div class="stat-num h2 fw-800 mt-2"><c:out value="${totalStudents}" default="0"/></div>
                            </div>
                            <i class="fa-solid fa-user-group text-primary fs-4 opacity-50"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="stat-lbl text-dim small fw-bold">EARNINGS</div>
                                <div class="stat-num h2 fw-800 mt-2">₹<c:out value="${earnings}" default="0"/></div>
                            </div>
                            <i class="fa-solid fa-wallet text-primary fs-4 opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-center py-5 rounded-5" style="background: var(--surface); border: 2px dashed rgba(255,255,255,0.1)">
                <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" width="60" class="mb-3 opacity-50">
                <h5 class="fw-bold mb-2">Create New Content</h5>
                <p class="text-dim mb-4 small">Add modules, lessons, and assignments to your courses.</p>
                <a href="${pageContext.request.contextPath}/teacher/courses/add" class="btn-create">
                    <i class="fa-solid fa-plus me-2"></i> Create New Course
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>