<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrolled Students | Instructor Hub</title>
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
        }

        body { background-color: var(--bg-dark); color: white; font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }

        /* ── Navbar ── */
        .portal-nav {
            background: rgba(9, 14, 26, 0.8);
            backdrop-filter: blur(10px);
            padding: 15px 40px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        /* ── Header ── */
        .page-header {
            padding: 30px 40px;
            margin-bottom: 10px;
        }

        /* ── Table Container ── */
        .table-container {
            background: var(--surface);
            border-radius: 24px;
            border: 1px solid var(--border);
            padding: 25px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            margin-bottom: 50px;
        }

        .custom-table { color: white; margin-bottom: 0; }
        .custom-table thead th {
            background: transparent;
            color: var(--text-dim);
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-weight: 700;
            border-bottom: 1px solid var(--border);
            padding: 15px;
        }

        .custom-table tbody tr { transition: 0.3s; }
        .custom-table tbody tr:hover { background: rgba(255,255,255,0.02); }

        .custom-table tbody td {
            padding: 20px 15px;
            border-bottom: 1px solid rgba(255,255,255,0.03);
            vertical-align: middle;
        }

        /* ── Student Avatar ── */
        .student-avatar {
            width: 45px; height: 45px;
            border-radius: 14px;
            background: linear-gradient(135deg, var(--primary), #3b82f6);
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; font-size: 1rem; color: white;
            box-shadow: 0 5px 15px rgba(78, 115, 223, 0.2);
        }

        /* ── Progress Bar ── */
        .progress-wrapper { width: 160px; }
        .progress-custom {
            height: 8px; background: rgba(255,255,255,0.05);
            border-radius: 10px; overflow: hidden;
        }
        .progress-fill { 
            height: 100%; 
            background: linear-gradient(90deg, var(--emerald), #34d399); 
            border-radius: 10px; 
            transition: width 1s ease-in-out;
        }

        /* ── Search Bar ── */
        .search-wrap { position: relative; max-width: 400px; }
        .search-wrap i { position: absolute; left: 18px; top: 14px; color: var(--text-dim); }
        .search-input {
            width: 100%; background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border); border-radius: 14px;
            padding: 12px 15px 12px 48px; color: white; outline: none; transition: 0.3s;
        }
        .search-input:focus { border-color: var(--primary); background: rgba(255, 255, 255, 0.08); }

        .btn-action {
            background: rgba(255,255,255,0.05); color: white;
            border: 1px solid var(--border); border-radius: 10px;
            padding: 8px 14px; font-size: 0.85rem; transition: 0.3s;
        }
        .btn-action:hover { background: var(--primary); border-color: var(--primary); transform: translateY(-2px); }
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
             style="width:35px; height:35px; cursor: pointer;" 
             onclick="location.href='${pageContext.request.contextPath}/teacher/profile'">
            <c:out value="${teacher.fullName.substring(0,1)}" default="T" />
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

<div class="page-header">
    <div class="container-fluid d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
        <div>
            <h3 class="fw-bold m-0"><i class="fa-solid fa-users-viewfinder text-primary me-2"></i>Students Directory</h3>
            <p class="small text-dim m-0">Tracking ${enrollments.size()} active learners across your courses</p>
        </div>
        <div class="search-wrap">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" id="studentSearch" placeholder="Search by name, email or course..." class="search-input">
        </div>
    </div>
</div>

<div class="container-fluid px-lg-5 px-3">
    
    <div class="table-container shadow-lg">
        <div class="table-responsive">
            <table class="table custom-table" id="studentTable">
                <thead>
                    <tr>
                        <th>Student Details</th>
                        <th>Enrolled Course</th>
                        <th>Learning Progress</th>
                        <th>Join Date</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="enroll" items="${enrollments}">
                        <tr class="student-row">
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                    <div class="student-avatar">
                                        <c:out value="${enroll.student.fullName.substring(0,1).toUpperCase()}" />
                                    </div>
                                    <div>
                                        <div class="fw-bold student-name text-white">${enroll.student.fullName}</div>
                                        <div class="small text-dim student-email">${enroll.student.email}</div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="fw-bold course-title text-white">${enroll.course.title}</div>
                                <div class="badge bg-primary bg-opacity-10 text-primary mt-1" style="font-size: 0.65rem;">
                                    ${enroll.course.category.name}
                                </div>
                            </td>
                            <td>
                                <div class="progress-wrapper">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="text-dim" style="font-size: 0.7rem;">Completed</span>
                                        <span class="text-success fw-bold" style="font-size: 0.7rem;">${enroll.progressPercent}%</span>
                                    </div>
                                    <div class="progress-custom">
                                        <div class="progress-fill" style="width: ${enroll.progressPercent}%"></div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="small fw-bold text-white">${enroll.enrolledAt}</div>
                                <div class="text-dim" style="font-size: 0.65rem;">ID: #ENR-${enroll.id}</div>
                            </td>
                            <td class="text-end">
                                <div class="d-flex justify-content-end gap-2">
                                    <a href="mailto:${enroll.student.email}" class="btn-action" title="Send Email">
                                        <i class="fa-solid fa-paper-plane"></i>
                                    </a>
                                    <button class="btn-action" title="View Progress Details">
                                        <i class="fa-solid fa-chart-pie"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty enrollments}">
                        <tr>
                            <td colspan="5" class="text-center py-5">
                                <div class="opacity-25 mb-3">
                                    <i class="fa-solid fa-user-graduate fa-4x text-primary"></i>
                                </div>
                                <h5 class="text-white">Your student list is empty</h5>
                                <p class="text-dim small">Promote your courses to see your student directory grow!</p>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    // Simple JavaScript for Real-time Search Filtering
    document.getElementById('studentSearch').addEventListener('keyup', function() {
        let filter = this.value.toLowerCase();
        let rows = document.querySelectorAll('.student-row');
        
        rows.forEach(row => {
            let name = row.querySelector('.student-name').innerText.toLowerCase();
            let email = row.querySelector('.student-email').innerText.toLowerCase();
            let course = row.querySelector('.course-title').innerText.toLowerCase();
            
            if (name.includes(filter) || email.includes(filter) || course.includes(filter)) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>