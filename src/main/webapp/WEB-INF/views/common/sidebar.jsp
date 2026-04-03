<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="cp" value="${pageContext.request.contextPath}"/>

<style>
    :root {
        --student-main: #6366f1;
        --teacher-main: #10b981;
        --admin-main: #ef4444;
    }

    .sidebar-sticky-wrapper { position: sticky; top: 100px; z-index: 10; }

    /* ── Cleaned & Fixed Sidebar Panel ── */
    .sidebar-panel {
        background: rgba(15, 23, 42, 0.4);
        backdrop-filter: blur(15px);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 24px;
        overflow: hidden;
        box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        min-width: 260px; /* Fixed width to prevent squishing */
        width: 100%;
    }

    .sidebar-header {
        padding: 25px 20px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        display: flex; align-items: center; gap: 15px;
        white-space: nowrap; /* Prevents text from breaking */
    }

    .sidebar-header-icon {
        width: 44px; height: 44px; border-radius: 14px;
        display: flex; align-items: center; justify-content: center;
        font-size: 1.1rem; color: white; flex-shrink: 0;
    }

    /* Role Specific Glows */
    .student-glow { background: linear-gradient(135deg, var(--student-main), #4338ca); box-shadow: 0 0 20px rgba(99, 102, 241, 0.3); }
    .teacher-glow { background: linear-gradient(135deg, var(--teacher-main), #059669); box-shadow: 0 0 20px rgba(16, 185, 129, 0.3); }
    .admin-glow { background: linear-gradient(135deg, var(--admin-main), #b91c1c); box-shadow: 0 0 20px rgba(239, 68, 68, 0.3); }

    .sidebar-menu { padding: 15px; }

    /* ── Fixed Menu Items ── */
    .sb-item {
        display: flex; align-items: center; gap: 12px;
        padding: 12px 16px; border-radius: 14px;
        font-size: 0.9rem; font-weight: 600;
        color: #94a3b8; text-decoration: none;
        transition: 0.3s; margin-bottom: 6px;
        white-space: nowrap; /* Keeps text on one line */
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .sb-icon {
        width: 32px; height: 32px; border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        background: rgba(255, 255, 255, 0.03); transition: 0.3s; flex-shrink: 0;
    }

    /* Student Hover/Active */
    .sb-item.student:hover, .sb-item.student.active { background: rgba(99, 102, 241, 0.1); color: white; }
    .sb-item.student.active .sb-icon, .sb-item.student:hover .sb-icon { background: var(--student-main); color: white; box-shadow: 0 0 10px rgba(99, 102, 241, 0.3); }

    /* Teacher Hover/Active */
    .sb-item.teacher:hover, .sb-item.teacher.active { background: rgba(16, 185, 129, 0.1); color: white; }
    .sb-item.teacher.active .sb-icon, .sb-item.teacher:hover .sb-icon { background: var(--teacher-main); color: white; box-shadow: 0 0 10px rgba(16, 185, 129, 0.3); }

    /* Admin Hover/Active */
    .sb-item.admin:hover, .sb-item.admin.active { background: rgba(239, 68, 68, 0.1); color: white; }
    .sb-item.admin.active .sb-icon, .sb-item.admin:hover .sb-icon { background: var(--admin-main); color: white; box-shadow: 0 0 10px rgba(239, 68, 68, 0.3); }

    .sb-divider { height: 1px; background: rgba(255,255,255,0.05); margin: 15px 10px; }

    .sb-logout-btn {
        width: 100%; border: none; background: transparent;
        display: flex; align-items: center; gap: 12px;
        padding: 12px 16px; border-radius: 14px;
        color: #ef4444; font-weight: 700; font-size: 0.9rem;
        transition: 0.3s; cursor: pointer; white-space: nowrap;
    }
    .sb-logout-btn:hover { background: rgba(239, 68, 68, 0.1); transform: translateX(5px); }
</style>

<div class="sidebar-sticky-wrapper">

    <%-- ── STUDENT SIDEBAR ── --%>
    <sec:authorize access="hasRole('STUDENT')">
        <div class="sidebar-panel">
            <div class="sidebar-header">
                <div class="sidebar-header-icon student-glow">
                    <i class="fa-solid fa-graduation-cap"></i>
                </div>
                <div>
                    <div class="fw-800 text-white small">STUDENT PORTAL</div>
                    <div class="text-muted" style="font-size: 0.65rem; letter-spacing: 1px;">LEARNER HUB</div>
                </div>
            </div>

            <div class="sidebar-menu">
                <a href="${cp}/student/dashboard" class="sb-item student ${pageTitle == 'Learning Dashboard' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-house-chimney"></i></span> Overview
                </a>
                <a href="${cp}/student/my-courses" class="sb-item student ${pageTitle == 'My Learning Library' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-play"></i></span> My Courses
                </a>
                <a href="${cp}/courses" class="sb-item student ${pageTitle == 'Explore Courses' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-compass"></i></span> Explore New
                </a>
                
                <%-- ✅ ADDED ASSIGNMENTS LINK --%>
                <a href="${cp}/student/assignments" class="sb-item student ${pageTitle == 'My Assignments' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-list-check"></i></span> Assignments
                </a>
                
                <a href="${cp}/student/certificates" class="sb-item student ${pageTitle == 'My Certificates' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-medal"></i></span> Certificates
                </a>
                <a href="${cp}/student/profile" class="sb-item student ${pageTitle == 'My Profile Settings' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-user-gear"></i></span> Settings
                </a>

                <div class="sb-divider"></div>
                <form action="${cp}/logout" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="sb-logout-btn">
                        <i class="fa-solid fa-right-from-bracket"></i> Sign Out
                    </button>
                </form>
            </div>
        </div>
    </sec:authorize>

    <%-- ── TEACHER SIDEBAR ── --%>
    <sec:authorize access="hasRole('TEACHER')">
        <div class="sidebar-panel">
            <div class="sidebar-header">
                <div class="sidebar-header-icon teacher-glow">
                    <i class="fa-solid fa-chalkboard-user"></i>
                </div>
                <div>
                    <div class="fw-800 text-white small">INSTRUCTOR</div>
                    <div class="text-muted" style="font-size: 0.65rem; letter-spacing: 1px;">CONTENT MANAGER</div>
                </div>
            </div>

            <div class="sidebar-menu">
                <%-- Added Active Logic for Teacher --%>
                <a href="${cp}/teacher/dashboard" class="sb-item teacher ${pageTitle == 'Instructor Dashboard' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-chart-line"></i></span> Analytics
                </a>
                <a href="${cp}/teacher/courses" class="sb-item teacher ${pageTitle == 'Manage Courses' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-book"></i></span> My Courses
                </a>
                <a href="${cp}/teacher/courses/add" class="sb-item teacher ${pageTitle == 'Create Course' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-plus-circle"></i></span> Create New
                </a>
                <a href="${cp}/teacher/earnings" class="sb-item teacher ${pageTitle == 'Revenue' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-wallet"></i></span> Revenue
                </a>

                <div class="sb-divider"></div>
                <form action="${cp}/logout" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="sb-logout-btn">
                        <i class="fa-solid fa-power-off"></i> Logout
                    </button>
                </form>
            </div>
        </div>
    </sec:authorize>

    <%-- ── ADMIN SIDEBAR ── --%>
    <sec:authorize access="hasRole('ADMIN')">
        <div class="sidebar-panel">
            <div class="sidebar-header">
                <div class="sidebar-header-icon admin-glow">
                    <i class="fa-solid fa-user-shield"></i>
                </div>
                <div>
                    <div class="fw-800 text-white small">ADMINISTRATOR</div>
                    <div class="text-muted" style="font-size: 0.65rem; letter-spacing: 1px;">SYSTEM CONTROL</div>
                </div>
            </div>

            <div class="sidebar-menu">
                <%-- Added Active Logic for Admin --%>
                <a href="${cp}/admin/dashboard" class="sb-item admin ${pageTitle == 'Admin Dashboard' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-grid-2"></i></span> Dashboard
                </a>
                <a href="${cp}/admin/users" class="sb-item admin ${pageTitle == 'Manage Users' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-users-gear"></i></span> Users
                </a>
                <a href="${cp}/admin/courses" class="sb-item admin ${pageTitle == 'Course Catalog' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-layer-group"></i></span> Catalog
                </a>
                <a href="${cp}/admin/categories" class="sb-item admin ${pageTitle == 'Manage Categories' ? 'active' : ''}">
                    <span class="sb-icon"><i class="fa-solid fa-tags"></i></span> Categories
                </a>

                <div class="sb-divider"></div>
                <form action="${cp}/logout" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="sb-logout-btn">
                        <i class="fa-solid fa-lock"></i> Sign Out
                    </button>
                </form>
            </div>
        </div>
    </sec:authorize>
</div>