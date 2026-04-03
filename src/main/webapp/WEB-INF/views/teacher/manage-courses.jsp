<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Library | E-Learn Instructor</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-dark: #090e1a;
            --surface: #111827;
            --primary: #4e73df;
            --emerald: #10b981;
            --border: rgba(255, 255, 255, 0.08);
            --text-dim: #94a3b8;
            --danger: #ef4444;
        }

        body { background-color: var(--bg-dark); color: white; font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }
        .portal-nav { background: rgba(9, 14, 26, 0.8); backdrop-filter: blur(12px); padding: 15px 40px; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; }
        
        /* Sidebar Styling */
        .sidebar { background: var(--surface); border-radius: 24px; padding: 24px; height: fit-content; border: 1px solid rgba(255,255,255,0.05); }
        .nav-item-link { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; color: var(--text-dim); text-decoration: none; transition: 0.3s; margin-top: 8px; font-weight: 500;}
        .nav-item-link:hover, .nav-item-link.active { background: rgba(78, 115, 223, 0.1); color: var(--primary); }
        .nav-item-link.logout { color: var(--danger); margin-top: 30px; }

        /* Main Content Styling */
        .main-content { padding: 0; }
        .header-section { margin-bottom: 30px; }
        
        .search-box { background: var(--surface); border: 1px solid var(--border); border-radius: 14px; padding: 10px 20px; display: flex; align-items: center; gap: 12px; width: 350px; }
        .search-box input { background: transparent; border: none; color: white; outline: none; width: 100%; font-size: 0.9rem; }

        .course-card { background: var(--surface); border: 1px solid var(--border); border-radius: 24px; overflow: hidden; transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1); height: 100%; display: flex; flex-direction: column; position: relative; }
        .course-card:hover { transform: translateY(-10px); border-color: var(--primary); box-shadow: 0 30px 60px rgba(0,0,0,0.5); }

        .thumb-container { position: relative; height: 190px; overflow: hidden; }
        .course-thumb { width: 100%; height: 100%; object-fit: cover; transition: 0.6s; }
        .course-card:hover .course-thumb { transform: scale(1.1) rotate(1deg); }

        .status-badge { position: absolute; top: 15px; right: 15px; padding: 6px 14px; border-radius: 50px; font-size: 0.65rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.5px; z-index: 2; }
        .bg-live { background: #064e3b; color: #34d399; border: 1px solid #059669; }
        .bg-draft { background: #451a03; color: #fbbf24; border: 1px solid #d97706; }

        .card-body-content { padding: 25px; flex-grow: 1; }
        .course-cat { font-size: 0.7rem; color: var(--primary); font-weight: 800; margin-bottom: 8px; text-transform: uppercase; }
        .course-title { font-size: 1.15rem; font-weight: 700; margin-bottom: 15px; color: white; line-height: 1.4; min-height: 50px; }

        .stats-row { border-top: 1px solid var(--border); padding-top: 15px; display: flex; justify-content: space-between; }
        .stat-item { display: flex; align-items: center; gap: 6px; font-size: 0.75rem; color: var(--text-dim); }

        .card-footer-actions { padding: 15px 25px 25px; display: flex; gap: 12px; align-items: center; }
        .btn-action { flex: 1; padding: 12px; border-radius: 12px; font-size: 0.85rem; font-weight: 700; text-decoration: none; text-align: center; transition: 0.3s; }
        .btn-edit { background: rgba(78, 115, 223, 0.1); color: var(--primary); border: 1px solid var(--primary); }
        .btn-edit:hover { background: var(--primary); color: white; }
        
        .btn-modules { background: rgba(16, 185, 129, 0.1); color: var(--emerald); border: 1px solid var(--emerald); }
        .btn-modules:hover { background: var(--emerald); color: white; }

        .btn-delete { color: #ef4444; background: rgba(239, 68, 68, 0.05); border: 1px solid rgba(239, 68, 68, 0.2); width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; transition: 0.3s; cursor: pointer; }
        .btn-delete:hover { background: #ef4444; color: white; }

        .btn-add-new { background: linear-gradient(135deg, var(--primary) 0%, #3b82f6 100%); color: white; padding: 14px 28px; border-radius: 16px; font-weight: 800; text-decoration: none; box-shadow: 0 10px 25px rgba(59, 130, 246, 0.3); }
    </style>
</head>
<body>

<nav class="portal-nav d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center gap-2" onclick="location.href='${pageContext.request.contextPath}/teacher/dashboard'" style="cursor: pointer;">
        <div class="bg-primary p-2 rounded-3 text-white"><i class="fa-solid fa-graduation-cap"></i></div>
        <h4 class="m-0 fw-bold text-white">E-Learn</h4>
    </div>
    
    <div class="d-flex align-items-center gap-4">
        <div class="bg-warning rounded-circle text-dark fw-bold d-flex align-items-center justify-content-center" 
             style="width:38px; height:38px; cursor: pointer;" 
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

<div class="container-fluid px-lg-5 px-3 mb-5">
    <div class="row g-4 mt-2">
        
        <%-- LEFT SIDEBAR (Closed Properly Now) --%>
        <div class="col-lg-3">
            <div class="sidebar shadow-sm">
                <div class="portal-label mb-3" style="font-size:0.65rem; color:var(--text-dim); font-weight:800;">MENU</div>
                <a href="${pageContext.request.contextPath}/teacher/dashboard" class="nav-item-link"><i class="fa-solid fa-house"></i> Overview</a>
                <a href="${pageContext.request.contextPath}/teacher/courses" class="nav-item-link active"><i class="fa-solid fa-book-open"></i> My Courses</a>
                <a href="${pageContext.request.contextPath}/teacher/assignments" class="nav-item-link"><i class="fa-solid fa-file-signature"></i> Assessments</a>
                <a href="${pageContext.request.contextPath}/teacher/courses/students" class="nav-item-link"><i class="fa-solid fa-users"></i> Student List</a>
                <a href="${pageContext.request.contextPath}/teacher/revenue" class="nav-item-link"><i class="fa-solid fa-chart-line"></i> Analytics</a>
                <a href="${pageContext.request.contextPath}/teacher/profile" class="nav-item-link"><i class="fa-solid fa-user-circle"></i> My Profile</a>
                
<a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link logout">
    <i class="fa-solid fa-right-from-bracket"></i> Sign Out
</a>  
            </div>
        </div>

        <%-- RIGHT CONTENT AREA (Wrapped in col-lg-9) --%>
        <div class="col-lg-9">
            <div class="main-content">
                
                <c:if test="${not empty successMsg}">
                    <div class="alert alert-success border-0 rounded-4 mb-4 shadow-sm">
                        <i class="fa-solid fa-circle-check me-2"></i> ${successMsg}
                    </div>
                </c:if>

                <div class="header-section d-flex justify-content-between align-items-end flex-wrap gap-4">
                    <div>
                        <h2 class="fw-bold m-0 text-white mb-2">My Course Library 📚</h2>
                        <p class="text-dim m-0">You have <b><c:out value="${courses.size()}" default="0"/></b> courses in your curriculum.</p>
                    </div>
                    
                    <div class="d-flex gap-3 align-items-center">
                        <div class="search-box d-none d-md-flex">
                            <i class="fa-solid fa-magnifying-glass text-dim"></i>
                            <input type="text" id="courseSearch" placeholder="Search courses..." onkeyup="filterCourses()">
                        </div>
                        <a href="${pageContext.request.contextPath}/teacher/courses/add" class="btn-add-new">
                            <i class="fa-solid fa-plus me-2"></i>New Course
                        </a>
                    </div>
                </div>

                <div class="row g-4" id="courseContainer">
                    <c:forEach var="course" items="${courses}">
                        <div class="col-xl-4 col-md-6 course-item-wrapper">
                            <div class="course-card">
                                <div class="thumb-container">
                                    <c:choose>
                                        <c:when test="${not empty course.thumbnailUrl}">
                                            <img src="${course.thumbnailUrl}" class="course-thumb" alt="thumbnail">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=80" class="course-thumb" alt="default">
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <span class="status-badge ${course.published ? 'bg-live' : 'bg-draft'}">
                                        <i class="fa-solid fa-circle me-1" style="font-size: 0.4rem;"></i>
                                        ${course.published ? 'Published' : 'Draft'}
                                    </span>
                                </div>

                                <div class="card-body-content">
                                    <div class="course-cat"><c:out value="${course.category.name}" default="Course"/></div>
                                    <h5 class="course-title"><c:out value="${course.title}"/></h5>
                                    
                                    <div class="stats-row">
                                        <div class="stat-item"><i class="fa-solid fa-users text-primary"></i> <c:out value="${course.totalEnrollments}" default="0"/> Students</div>
                                        <div class="stat-item fw-bold text-white">₹<c:out value="${course.price}" default="0.00"/></div>
                                    </div>
                                </div>

                                <div class="card-footer-actions">
                                    <a href="${pageContext.request.contextPath}/teacher/courses/edit/${course.id}" class="btn-action btn-edit">
                                        <i class="fa-solid fa-sliders"></i> Edit
                                    </a>
                                    <a href="${pageContext.request.contextPath}/teacher/courses/${course.id}/modules" class="btn-action btn-modules">
                                        <i class="fa-solid fa-wand-magic-sparkles"></i> Builder
                                    </a>
                                    
                                    <form action="${pageContext.request.contextPath}/teacher/courses/delete/${course.id}" method="post" style="display:inline; margin:0;">
                                         <button type="submit" class="btn-delete" onclick="return confirm('Attention: All course data, modules, and lessons will be deleted permanently. Continue?')">
                                            <i class="fa-solid fa-trash-can"></i>
                                         </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty courses}">
                        <div class="col-12 text-center py-5 rounded-5 mt-4" style="background: rgba(255,255,255,0.02); border: 2px dashed var(--border)">
                            <div class="opacity-25 mb-3 text-primary"><i class="fa-solid fa-box-open fa-4x"></i></div>
                            <h4 class="text-white fw-bold">No courses found</h4>
                            <a href="${pageContext.request.contextPath}/teacher/courses/add" class="btn btn-primary rounded-pill px-5 mt-3">Start Creating</a>
                        </div>
                    </c:if>
                </div>
                
            </div>
        </div> <%-- End of col-lg-9 --%>
        
    </div> <%-- End of Row --%>
</div> <%-- End of Container --%>

<script>
    function filterCourses() {
        let input = document.getElementById('courseSearch').value.toLowerCase();
        let items = document.getElementsByClassName('course-item-wrapper');
        
        for (let i = 0; i < items.length; i++) {
            let title = items[i].querySelector('.course-title').innerText.toLowerCase();
            items[i].style.display = title.includes(input) ? "" : "none";
        }
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>