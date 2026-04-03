<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessments Center | E-Learn Instructor</title>
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
        
        /* Navbar */
        .portal-nav { background: rgba(9, 14, 26, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; }
        
        /* Sidebar Styling */
        .sidebar { background: var(--surface); border-radius: 24px; padding: 24px; height: fit-content; border: 1px solid rgba(255,255,255,0.05); }
        .nav-item-link { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; color: var(--text-dim); text-decoration: none; transition: 0.3s; margin-top: 8px; font-weight: 500;}
        .nav-item-link:hover, .nav-item-link.active { background: rgba(78, 115, 223, 0.1); color: var(--primary); }
        .nav-item-link.logout { color: var(--danger); margin-top: 30px; }

        /* Main Content */
        .main-content { padding: 0; }
        .header-section { background: var(--surface); padding: 30px; border: 1px solid var(--border); border-radius: 20px; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; }
        
        .search-container { position: relative; max-width: 300px; }
        .search-input { background: rgba(255, 255, 255, 0.03); border: 1px solid var(--border); border-radius: 12px; padding: 10px 15px 10px 40px; color: white; width: 100%; transition: 0.3s; }
        .search-input:focus { border-color: var(--primary); outline: none; background: rgba(255, 255, 255, 0.06); }
        .search-icon { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--text-dim); }

        .assessment-card { background: var(--surface); border: 1px solid var(--border); border-radius: 24px; padding: 25px; margin-bottom: 20px; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); position: relative; }
        .assessment-card:hover { border-color: var(--primary); transform: translateY(-5px); box-shadow: 0 20px 40px rgba(0,0,0,0.4); }
        
        .icon-box { width: 52px; height: 52px; border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; }
        .modal-content { background: var(--surface); border: 1px solid var(--border); border-radius: 32px; color: white; }
        .custom-input, .custom-select { background: rgba(255, 255, 255, 0.03); border: 1px solid var(--border); border-radius: 14px; padding: 12px; color: white; margin-bottom: 20px; width: 100%; outline: none; }
        .custom-select option { background: var(--surface); color: white; }

        .btn-create { background: linear-gradient(135deg, var(--primary), #3b82f6); color: white; border: none; padding: 12px 24px; border-radius: 12px; font-weight: 700; display: inline-flex; align-items: center;}
        .btn-create:hover { background: #3b5bdb; transform: translateY(-2px); }
        
        .type-pill { padding: 4px 12px; border-radius: 8px; font-size: 0.7rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; }
        
        .bg-quiz { background: rgba(78, 115, 223, 0.15); color: #8ea8f3; border: 1px solid rgba(78, 115, 223, 0.3); }
        .bg-task { background: rgba(16, 185, 129, 0.15); color: #6ee7b7; border: 1px solid rgba(16, 185, 129, 0.3); }
        
        .bg-quiz-light { background: rgba(78, 115, 223, 0.1); color: var(--primary); }
        .bg-task-light { background: rgba(16, 185, 129, 0.1); color: var(--emerald); }

        .course-info-box { background: rgba(255, 255, 255, 0.02); padding: 12px; border-radius: 16px; margin-bottom: 15px; border: 1px solid var(--border); }
        .nav-pills .nav-link { color: var(--text-dim); border-radius: 12px; padding: 10px 20px; font-weight: 600; }
        .nav-pills .nav-link.active { background: var(--primary); color: white; }
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
        
        <%-- LEFT SIDEBAR --%>
        <div class="col-lg-3">
            <div class="sidebar shadow-sm">
                <div class="portal-label mb-3" style="font-size:0.65rem; color:var(--text-dim); font-weight:800;">MENU</div>
                <a href="${pageContext.request.contextPath}/teacher/dashboard" class="nav-item-link"><i class="fa-solid fa-house"></i> Overview</a>
                <a href="${pageContext.request.contextPath}/teacher/courses" class="nav-item-link"><i class="fa-solid fa-book-open"></i> My Courses</a>
                <a href="${pageContext.request.contextPath}/teacher/assignments" class="nav-item-link active"><i class="fa-solid fa-file-signature"></i> Assessments</a>
                <a href="${pageContext.request.contextPath}/teacher/courses/students" class="nav-item-link"><i class="fa-solid fa-users"></i> Student List</a>
                <a href="${pageContext.request.contextPath}/teacher/revenue" class="nav-item-link"><i class="fa-solid fa-chart-line"></i> Analytics</a>
                <a href="${pageContext.request.contextPath}/teacher/profile" class="nav-item-link"><i class="fa-solid fa-user-circle"></i> My Profile</a>
                
<a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link logout">
    <i class="fa-solid fa-right-from-bracket"></i> Sign Out
</a>  
            </div>
        </div>

        <%-- RIGHT CONTENT AREA --%>
        <div class="col-lg-9">
            <div class="main-content">

                <div class="header-section">
                    <div>
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <h2 class="fw-bold m-0 text-white">Assessments Center ✍️</h2>
                        </div>
                        <p class="text-dim m-0">Manage and track <c:out value="${activeAssignments.size()}" default="0"/> published assessments.</p>
                    </div>
                    
                    <div class="d-flex gap-3 align-items-center">
                        <div class="search-container d-none d-md-block">
                            <i class="fa-solid fa-magnifying-glass search-icon"></i>
                            <input type="text" class="search-input" id="assessmentSearch" placeholder="Search assessments..." onkeyup="filterAssessments()">
                        </div>
                        <button class="btn-create shadow-lg" data-bs-toggle="modal" data-bs-target="#typeSelectionModal">
                            <i class="fa-solid fa-plus-circle me-2"></i> New Assessment
                        </button>
                    </div>
                </div>

                <c:if test="${not empty successMsg}">
                    <div class="alert alert-success border-0 rounded-4 mb-4 shadow-sm bg-success bg-opacity-10 text-success">
                        <i class="fa-solid fa-circle-check me-2"></i> ${successMsg}
                    </div>
                </c:if>

                <ul class="nav nav-pills mb-4 gap-2" id="pills-tab" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#activeTab">Manage Library</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="pill" data-bs-target="#submissionsTab">Student Submissions</button>
                    </li>
                </ul>

                <div class="tab-content">
                    <%-- TAB: ACTIVE ASSIGNMENTS --%>
                    <div class="tab-pane fade show active" id="activeTab">
                        <div class="row g-4" id="assessmentContainer">
                            <c:forEach var="task" items="${activeAssignments}">
                                <div class="col-md-6 assessment-item">
                                    <div class="assessment-card h-100 d-flex flex-column justify-content-between">
                                        <div>
                                            <div class="d-flex justify-content-between mb-3 align-items-center">
                                                <span class="type-pill ${task.type == 'QUIZ' ? 'bg-quiz' : 'bg-task'}">
                                                    <i class="fa-solid ${task.type == 'QUIZ' ? 'fa-bolt' : 'fa-file-lines'} me-1"></i> ${task.type}
                                                </span>
                                                <span class="small text-dim">Due: <fmt:parseDate value="${task.dueDate}" pattern="yyyy-MM-dd" var="parsedDate" />
                                                <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy" /></span>
                                            </div>
                                            
                                            <h5 class="fw-bold text-white mb-3 assessment-title"><c:out value="${task.title}"/></h5>
                                            
                                            <div class="course-info-box">
                                                <div class="small text-white mb-1">
                                                    <i class="fa-solid fa-book-open text-primary me-2 opacity-75"></i>
                                                    <c:out value="${task.module.course.title}"/>
                                                </div>
                                                <div class="small text-dim">
                                                    <i class="fa-solid fa-folder-tree text-emerald me-2 opacity-75"></i>
                                                    <c:out value="${task.module.title}"/>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="pt-3 border-top border-secondary border-opacity-10 d-flex justify-content-between align-items-center">
                                            <span class="text-primary fw-bold bg-primary bg-opacity-10 px-3 py-1 rounded-pill small">${task.maxMarks} Marks</span>
                                            
                                            <div class="d-flex gap-2">
                                                <c:if test="${task.type == 'QUIZ'}">
                                                    <a href="${pageContext.request.contextPath}/teacher/assignments/${task.id}/questions" class="btn btn-sm btn-outline-info border-0 rounded-circle d-flex align-items-center justify-content-center" title="Edit Quiz Questions" style="width:35px; height:35px;">
                                                        <i class="fa-solid fa-list-check"></i>
                                                    </a>
                                                </c:if>
                                                
                                                <form action="${pageContext.request.contextPath}/teacher/assignments/delete/${task.id}" method="post" class="m-0">
                                                    <button type="submit" class="btn btn-sm text-danger border-0 bg-danger bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width:35px; height:35px;" onclick="return confirm('Are you sure you want to delete this assessment?')">
                                                        <i class="fa-solid fa-trash-can"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <c:if test="${empty activeAssignments}">
                                <div class="col-12 text-center py-5 rounded-4" style="border: 2px dashed var(--border); background: var(--surface);">
                                    <i class="fa-solid fa-file-circle-plus fa-3x text-dim mb-3 opacity-25"></i>
                                    <h6 class="text-white">No assessments found.</h6>
                                    <p class="small text-dim">Create your first assessment to see it here.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <%-- TAB: SUBMISSIONS --%>
                    <div class="tab-pane fade" id="submissionsTab">
                        <c:forEach var="sub" items="${submissions}">
                            <div class="assessment-card d-flex justify-content-between align-items-center">
                                <div class="d-flex align-items-center gap-4">
                                    <div class="icon-box ${sub.assignment.type == 'QUIZ' ? 'bg-quiz-light' : 'bg-task-light'}">
                                        <i class="fa-solid ${sub.assignment.type == 'QUIZ' ? 'fa-bolt-lightning' : 'fa-file-signature'}"></i>
                                    </div>
                                    <div>
                                        <span class="type-pill ${sub.assignment.type == 'QUIZ' ? 'bg-quiz' : 'bg-task'} mb-2 d-inline-block">
                                            ${sub.assignment.type}
                                        </span>
                                        <h5 class="fw-bold m-0 text-white">${sub.assignment.title}</h5>
                                        <div class="small text-dim mt-1">Course: <span class="text-white">${sub.assignment.module.course.title}</span></div>
                                        <div class="small text-dim">Student: <b class="text-white">${sub.student.fullName}</b></div>
                                    </div>
                                </div>
                                <div class="text-end d-flex gap-3 align-items-center">
                                    <c:if test="${sub.graded}">
                                        <span class="badge bg-success bg-opacity-25 text-success px-3 py-2 rounded-pill">Graded</span>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/teacher/review-assignments" class="btn btn-sm btn-outline-light rounded-pill px-4">Review</a>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <c:if test="${empty submissions}">
                            <div class="text-center py-5 text-dim border border-secondary border-opacity-25 rounded-4 border-dashed">
                                <i class="fa-solid fa-inbox fa-3x mb-3 opacity-25"></i>
                                <h6>No pending submissions.</h6>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div> <%-- End Main Content --%>
        </div> <%-- End Col-9 --%>
    </div>
</div>

<%-- Modals --%>
<div class="modal fade" id="typeSelectionModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg border-0">
            <div class="modal-body p-5 text-center">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold m-0 text-white">Select Format</h4>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="row g-3">
                    <div class="col-6" onclick="openForm('TASK')" style="cursor:pointer;">
                        <div class="p-4 rounded-4 border border-secondary border-opacity-25 bg-white bg-opacity-5 hover-border-primary">
                            <i class="fa-solid fa-file-pen fa-3x text-emerald mb-3"></i>
                            <h6 class="fw-bold m-0 text-white">Writing Task</h6>
                        </div>
                    </div>
                    <div class="col-6" onclick="openForm('QUIZ')" style="cursor:pointer;">
                        <div class="p-4 rounded-4 border border-secondary border-opacity-25 bg-white bg-opacity-5 hover-border-primary">
                            <i class="fa-solid fa-list-check fa-3x text-primary mb-3"></i>
                            <h6 class="fw-bold m-0 text-white">MCQ Quiz</h6>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="mainFormModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0">
            <div class="modal-body p-5">
                <h3 class="fw-bold mb-4 text-white" id="formTitle">Create Assessment</h3>
                <form action="${pageContext.request.contextPath}/teacher/assignments/save" method="post">
                    <input type="hidden" name="type" id="assessmentType">
                    
                    <div class="mb-4">
                        <label class="small text-dim fw-bold mb-2">ASSESSMENT TITLE</label>
                        <input type="text" name="title" class="custom-input" placeholder="e.g. Core Java Basic Quiz" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <label class="small text-dim fw-bold mb-2">TARGET MODULE</label>
                            <select name="moduleId" class="custom-select" required>
                                <option value="" disabled selected>-- Choose Module --</option>
                                <c:forEach var="m" items="${modules}">
                                    <option value="${m.id}"><c:out value="${m.course.title} - ${m.title}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="small text-dim fw-bold mb-2">MAX MARKS</label>
                            <input type="number" name="maxMarks" class="custom-input" value="100" min="1">
                        </div>
                        <div class="col-md-3">
                            <label class="small text-dim fw-bold mb-2">DUE DATE</label>
                            <input type="date" id="deadlineDate" name="dueDate" class="custom-input" required>
                        </div>
                    </div>

                    <div id="taskSection">
                        <label class="small text-dim fw-bold mb-2">INSTRUCTIONS</label>
                        <textarea name="description" class="custom-input" style="height: 120px;" placeholder="What should students upload?"></textarea>
                    </div>

                    <div id="quizSection" style="display: none;">
                        <div class="alert alert-primary bg-primary bg-opacity-10 border-0 rounded-4 p-4 text-center mt-3">
                            <i class="fa-solid fa-wand-magic-sparkles fa-2x mb-3 text-primary"></i>
                            <p class="m-0 text-white small">Publish karne ke baad aap sidha **Quiz Builder** me questions add kar payenge.</p>
                        </div>
                    </div>

                    <button type="submit" class="btn-create w-100 py-3 mt-3 shadow-lg justify-content-center">Publish Assessment</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function filterAssessments() {
        let input = document.getElementById('assessmentSearch').value.toLowerCase();
        let items = document.getElementsByClassName('assessment-item');
        for (let i = 0; i < items.length; i++) {
            let title = items[i].querySelector('.assessment-title').innerText.toLowerCase();
            items[i].style.display = title.includes(input) ? "" : "none";
        }
    }

    function openForm(type) {
        bootstrap.Modal.getInstance(document.getElementById('typeSelectionModal')).hide();
        document.getElementById('assessmentType').value = type;
        document.getElementById('formTitle').innerText = type === 'QUIZ' ? 'New MCQ Quiz ⏱️' : 'New Writing Task ✍️';
        document.getElementById('taskSection').style.display = type === 'TASK' ? 'block' : 'none';
        document.getElementById('quizSection').style.display = type === 'QUIZ' ? 'block' : 'none';
        new bootstrap.Modal(document.getElementById('mainFormModal')).show();
    }
</script>
</body>
</html>