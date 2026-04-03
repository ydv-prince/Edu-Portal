<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${pageTitle != null ? pageTitle : 'Home'} | E-Learn Platform</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    
    <style>
        :root {
            --dark-1      : #020617;
            --primary     : #6366f1;
            --primary-d   : #4f46e5;
            --warning     : #f59e0b;
            --text-main   : #f8fafc;
            --text-muted  : #94a3b8;
            --border      : rgba(255,255,255,0.08);
            --glass       : rgba(15, 23, 42, 0.8);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--dark-1);
            color: var(--text-main);
            margin: 0; padding: 0;
            min-height: 100vh;
        }

        /* Ambient Glow */
        body::before {
            content: ''; position: fixed; inset: 0;
            background: radial-gradient(circle at 15% 15%, rgba(99, 102, 241, 0.08) 0%, transparent 50%),
                        radial-gradient(circle at 85% 85%, rgba(168, 85, 247, 0.05) 0%, transparent 50%);
            z-index: -1; pointer-events: none;
        }

        /* Navbar Styling */
        .elearn-navbar {
            background: var(--glass) !important;
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            height: 72px;
            position: sticky; top: 0; z-index: 1000;
        }

        .nav-brand-icon {
            width: 42px; height: 42px; border-radius: 12px;
            background: linear-gradient(135deg, var(--primary), var(--primary-d));
            display: flex; align-items: center; justify-content: center;
            color: white; box-shadow: 0 8px 16px rgba(99, 102, 241, 0.2);
            font-size: 1.2rem;
        }

        .nav-search input {
            background: rgba(0,0,0,0.2); border: 1.5px solid var(--border);
            border-radius: 12px; padding: 10px 20px; color: white; width: 300px; transition: 0.3s;
            font-size: 0.9rem;
        }
        .nav-search input:focus { width: 350px; background: rgba(0,0,0,0.4); outline: none; border-color: var(--primary); }

        .nav-link-item { color: var(--text-muted); font-weight: 600; font-size: 0.9rem; padding: 10px 16px; border-radius: 10px; transition: 0.2s; text-decoration: none;}
        .nav-link-item:hover { color: white; background: rgba(255,255,255,0.05); }

        /* Modern Avatar */
        .nav-avatar {
            width: 40px; height: 40px; border-radius: 12px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; color: white; cursor: pointer; border: 1.5px solid var(--border);
            overflow: hidden; transition: 0.3s;
        }
        .nav-avatar:hover { transform: scale(1.05); border-color: var(--primary); }
        .nav-avatar img { width: 100%; height: 100%; object-fit: cover; }

        .dropdown-menu-dark {
            background: #0f172a !important; border: 1px solid var(--border) !important;
            border-radius: 16px !important; box-shadow: 0 20px 40px rgba(0,0,0,0.4) !important;
            padding: 10px !important; margin-top: 10px !important;
        }

        .dropdown-item { border-radius: 10px !important; padding: 10px 15px !important; transition: 0.2s !important; }
        .dropdown-item:hover { background: rgba(99, 102, 241, 0.1) !important; color: var(--primary) !important; }

        .page-wrapper { min-height: calc(100vh - 72px); }
        .container-main { max-width: 1400px; margin: 0 auto; padding: 24px; }

        /* Flash Messages */
        .flash-msg { border-radius: 14px !important; border: none !important; backdrop-filter: blur(10px); }
    </style>
</head>
<body>

<nav class="elearn-navbar d-flex align-items-center">
    <div class="container-fluid d-flex align-items-center justify-content-between px-lg-5">
        
        <div class="d-flex align-items-center gap-4">
            <a href="${pageContext.request.contextPath}/" class="text-decoration-none d-flex align-items-center gap-3">
                <div class="nav-brand-icon"><i class="fa-solid fa-graduation-cap"></i></div>
                <span class="fw-900 fs-4 text-white" style="letter-spacing: -1px;">E-<span style="color: var(--warning)">LEARN</span></span>
            </a>

            <form class="nav-search d-none d-xl-block" action="${pageContext.request.contextPath}/courses" method="get">
                <div class="position-relative">
                    <input type="text" name="keyword" placeholder="Search courses, skills..." value="${param.keyword}"/>
                    <i class="fa-solid fa-magnifying-glass position-absolute top-50 end-0 translate-middle-y me-3 text-muted"></i>
                </div>
            </form>
        </div>

        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/courses" class="nav-link-item d-none d-md-block">
                <i class="fa-solid fa-compass me-2"></i>Explore
            </a>

            <sec:authorize access="isAnonymous()">
                <a href="${pageContext.request.contextPath}/auth/login" class="nav-link-item">Login</a>
                <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-primary px-4 rounded-pill fw-800 shadow-sm border-0">Get Started</a>
            </sec:authorize>

            <sec:authorize access="isAuthenticated()">
                <%-- Notification Bell --%>
                <div class="position-relative cursor-pointer text-muted fs-5 mx-2 p-2 hover-white">
                    <i class="fa-solid fa-bell"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger p-1" style="font-size: 0.4rem; border: 2px solid #0f172a;"> </span>
                </div>

                <div class="dropdown">
                    <div class="nav-avatar" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                        <%-- ✅ FIXED: Universal logic to capture user object regardless of controller --%>
                        <c:set var="loggedInUser" value="${not empty student ? student : (not empty teacher ? teacher : (not empty user ? user : null))}" />
                        <c:choose>
                            <c:when test="${not empty loggedInUser and not empty loggedInUser.profilePicture}">
                                <img src="${pageContext.request.contextPath}${loggedInUser.profilePicture}" alt="Profile">
                            </c:when>
                            <c:otherwise>
                                <sec:authentication property="principal.username" var="username"/>
                                ${username.substring(0,1).toUpperCase()}
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark shadow-lg mt-3">
                        <li class="px-3 py-3 border-bottom border-white-50 border-opacity-10 mb-2">
                            <sec:authentication property="principal.username" var="username"/>
                            <div class="fw-800 text-white small">${username}</div>
                            <div class="text-muted" style="font-size: 0.7rem">
                                <sec:authorize access="hasRole('STUDENT')">Verified Student</sec:authorize>
                                <sec:authorize access="hasRole('TEACHER')">Certified Instructor</sec:authorize>
                                <sec:authorize access="hasRole('ADMIN')">Portal Administrator</sec:authorize>
                            </div>
                        </li>

                        <sec:authorize access="hasRole('STUDENT')">
                            <li><a class="dropdown-item small fw-600" href="${pageContext.request.contextPath}/student/dashboard"><i class="fa-solid fa-gauge-high me-2"></i>My Dashboard</a></li>
                            <li><a class="dropdown-item small fw-600" href="${pageContext.request.contextPath}/student/profile"><i class="fa-solid fa-user-pen me-2"></i>Edit Profile</a></li>
                            <li><a class="dropdown-item small fw-600" href="${pageContext.request.contextPath}/student/certificates"><i class="fa-solid fa-award me-2"></i>My Certificates</a></li>
                        </sec:authorize>
                        
                        <sec:authorize access="hasRole('TEACHER')">
                            <li><a class="dropdown-item small fw-600" href="${pageContext.request.contextPath}/teacher/dashboard"><i class="fa-solid fa-chart-line me-2"></i>Instructor Panel</a></li>
                            <li><a class="dropdown-item small fw-600" href="${pageContext.request.contextPath}/teacher/profile"><i class="fa-solid fa-id-card me-2"></i>Teacher Profile</a></li>
                        </sec:authorize>

                        <li class="dropdown-divider border-white-50 border-opacity-10"></li>
                        
                        <li>
                            <form action="${pageContext.request.contextPath}/auth/logout" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button type="submit" class="dropdown-item small text-danger fw-800"><i class="fa-solid fa-power-off me-2"></i>Sign Out</button>
                            </form>
                        </li>
                    </ul>
                </div>
            </sec:authorize>
        </div>
    </div>
</nav>

<div class="container-main mt-3">
    <c:if test="${not empty successMsg}">
        <div class="alert alert-success flash-msg alert-dismissible fade show bg-success bg-opacity-10 text-success border-0 shadow-sm" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger flash-msg alert-dismissible fade show bg-danger bg-opacity-10 text-danger border-0 shadow-sm" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i> ${errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
</div>

<div class="page-wrapper">
    <div class="container-main">