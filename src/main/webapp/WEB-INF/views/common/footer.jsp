<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

    <%-- ✅ CRITICAL FIX: Close the wrapper divs opened in header.jsp --%>
    </div> </div> <footer class="footer-main mt-auto">
    <div class="container">
        <div class="row g-4">

            <%-- Column 1: Brand & About --%>
            <div class="col-lg-4 col-md-6">
                <div class="footer-brand mb-3">
                    <div class="brand-icon-box">
                        <i class="fa-solid fa-graduation-cap"></i>
                    </div>
                    <span class="brand-text">
                        E-<span class="accent">Learn</span>
                    </span>
                </div>
                <p class="footer-description">
                    Empowering learners across India with world-class education. 
                    Master industry-relevant skills from expert mentors and 
                    earn recognized certifications to build your dream career.
                </p>

                <div class="d-flex gap-2 mt-4">
                    <a href="#" class="footer-social" title="YouTube"><i class="fa-brands fa-youtube"></i></a>
                    <a href="#" class="footer-social" title="Instagram"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#" class="footer-social" title="LinkedIn"><i class="fa-brands fa-linkedin-in"></i></a>
                    <a href="#" class="footer-social" title="Twitter"><i class="fa-brands fa-x-twitter"></i></a>
                </div>
            </div>

            <%-- Column 2: Platform Links --%>
            <div class="col-lg-2 col-md-6 col-6">
                <h6 class="footer-heading">Platform</h6>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/courses">All Courses</a></li>
                    <li><a href="${pageContext.request.contextPath}/courses">Categories</a></li>
                    <li><a href="#">Mentors</a></li>
                    <li><a href="#">Verify Certificate</a></li>
                </ul>
            </div>

            <%-- Column 3: Account Links --%>
            <div class="col-lg-2 col-md-6 col-6">
                <h6 class="footer-heading">Account</h6>
                <ul class="footer-links">
                    <sec:authorize access="isAnonymous()">
                        <li><a href="${pageContext.request.contextPath}/auth/login">Sign In</a></li>
                        <li><a href="${pageContext.request.contextPath}/auth/register">Create Account</a></li>
                    </sec:authorize>
                    <sec:authorize access="isAuthenticated()">
                        <sec:authorize access="hasRole('STUDENT')">
                            <li><a href="${pageContext.request.contextPath}/student/dashboard">My Dashboard</a></li>
                            <li><a href="${pageContext.request.contextPath}/student/profile">Profile Settings</a></li>
                        </sec:authorize>
                        <sec:authorize access="hasRole('TEACHER')">
                            <li><a href="${pageContext.request.contextPath}/teacher/dashboard">Instructor Panel</a></li>
                        </sec:authorize>
                    </sec:authorize>
                    <li><a href="#">Help Center</a></li>
                </ul>
            </div>

            <%-- Column 4: Newsletter & Stats --%>
            <div class="col-lg-4 col-md-6">
                <h6 class="footer-heading">Newsletter</h6>
                <p class="footer-description mb-3" style="margin-top: 0;">
                    Subscribe to get the latest course updates and exclusive offers directly in your inbox.
                </p>
                <div class="footer-newsletter">
                    <input type="email" id="newsEmail" placeholder="Enter your email address" class="footer-input"/>
                    <button class="footer-sub-btn" onclick="handleSubscription()">Subscribe</button>
                </div>

                <div class="footer-stats-row">
                    <div class="stat-box">
                        <div class="footer-stat-num">50K+</div>
                        <div class="footer-stat-label">Learners</div>
                    </div>
                    <div class="stat-box">
                        <div class="footer-stat-num">1.2K+</div>
                        <div class="footer-stat-label">Courses</div>
                    </div>
                    <div class="stat-box">
                        <div class="footer-stat-num">250+</div>
                        <div class="footer-stat-label">Mentors</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            <div class="copyright">
                &copy; 2026 E-Learn EdTech Platform. All rights reserved.
            </div>
            <div class="footer-legal-links">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Contact Us</a>
            </div>
        </div>
    </div>
</footer>

<%-- ✅ FIX: Added missing Back to Top Button --%>
<button id="backToTop" class="back-to-top" onclick="window.scrollTo({top: 0, behavior: 'smooth'})" title="Go to top">
    <i class="fa-solid fa-arrow-up"></i>
</button>

<style>
.footer-main {
    background: #0a0a14;
    border-top: 1px solid rgba(255,255,255,0.06);
    padding: 70px 0 30px;
    position: relative;
    z-index: 10;
}
.footer-brand { display: flex; align-items: center; gap: 12px; }
.brand-icon-box {
    width: 42px; height: 42px; border-radius: 12px;
    background: linear-gradient(135deg, var(--primary, #4e73df), #224abe);
    display: flex; align-items: center; justify-content: center;
    color: white; font-size: 1.2rem; box-shadow: 0 5px 15px rgba(78,115,223,0.3);
}
.brand-text { font-size: 1.4rem; font-weight: 800; color: white; }
.brand-text .accent { color: var(--warning, #f6c23e); }

.footer-description {
    color: rgba(255,255,255,0.5); font-size: 0.9rem;
    line-height: 1.7; margin: 20px 0; max-width: 320px;
}

/* ✅ FIX: Social Icons Styling */
.footer-social {
    width: 38px; height: 38px; border-radius: 10px;
    background: rgba(255,255,255,0.05); color: rgba(255,255,255,0.6);
    display: flex; align-items: center; justify-content: center;
    text-decoration: none; transition: 0.3s; border: 1px solid rgba(255,255,255,0.08);
}
.footer-social:hover { 
    background: var(--primary, #4e73df); color: white; 
    transform: translateY(-4px); box-shadow: 0 8px 15px rgba(78,115,223,0.3); 
    border-color: transparent;
}

.footer-heading {
    color: white; font-weight: 800; font-size: 0.9rem;
    text-transform: uppercase; letter-spacing: 1px; margin-bottom: 24px;
}
.footer-links { list-style: none; padding: 0; }
.footer-links li { margin-bottom: 14px; }
.footer-links a {
    color: rgba(255,255,255,0.5); font-size: 0.9rem; font-weight: 500;
    text-decoration: none; transition: 0.3s; display: inline-block;
}
.footer-links a:hover { color: white; transform: translateX(5px); }

.footer-newsletter { display: flex; gap: 8px; margin-top: 10px; }
.footer-input {
    background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.1);
    border-radius: 10px; padding: 12px 16px; color: white; flex: 1; font-size: 0.9rem; outline: none; transition: 0.3s;
}
.footer-input:focus { border-color: var(--primary, #4e73df); background: rgba(0,0,0,0.3); }

.footer-sub-btn {
    background: var(--primary, #4e73df); border: none; border-radius: 10px; 
    padding: 10px 24px; color: white; font-weight: 700; font-size: 0.9rem; transition: 0.3s;
}
.footer-sub-btn:hover { background: #3b5bbf; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(78,115,223,0.3); }

.footer-stats-row { display: flex; justify-content: space-between; margin-top: 30px; padding-top: 25px; border-top: 1px solid rgba(255,255,255,0.06); }
.footer-stat-num { font-size: 1.3rem; font-weight: 900; color: white; margin-bottom: 2px; }
.footer-stat-label { font-size: 0.7rem; color: rgba(255,255,255,0.4); text-transform: uppercase; font-weight: 700; letter-spacing: 1px;}

.footer-bottom {
    margin-top: 50px; padding-top: 25px; border-top: 1px solid rgba(255,255,255,0.06);
    display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;
}
.copyright { color: rgba(255,255,255,0.4); font-size: 0.85rem; font-weight: 500;}
.footer-legal-links { display: flex; gap: 24px; }
.footer-legal-links a { color: rgba(255,255,255,0.4); text-decoration: none; font-size: 0.85rem; font-weight: 500; transition: 0.3s;}
.footer-legal-links a:hover { color: white; }

/* Toast Notification Style */
.toast-dark {
    position: fixed; bottom: 30px; left: 30px; z-index: 9999;
    background: #1a1a2e; color: white; padding: 16px 24px;
    border-radius: 12px; border-left: 4px solid var(--primary, #4e73df);
    display: flex; align-items: center; gap: 14px; font-weight: 600; font-size: 0.95rem;
    box-shadow: 0 10px 40px rgba(0,0,0,0.5);
    animation: slideIn 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
}
@keyframes slideIn { from { transform: translateX(-120%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

/* ✅ FIX: Back to top button styling */
.back-to-top {
    position: fixed; bottom: 30px; right: 30px; z-index: 999;
    width: 45px; height: 45px; border-radius: 12px;
    background: var(--primary, #4e73df); color: white; border: none;
    display: none; align-items: center; justify-content: center;
    font-size: 1.1rem; cursor: pointer; transition: 0.3s;
    box-shadow: 0 10px 25px rgba(78,115,223,0.4);
}
.back-to-top:hover { transform: translateY(-5px); background: #3b5bbf; }
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Newsletter Subscription Logic
    function handleSubscription() {
        const email = document.getElementById('newsEmail').value;
        if(email && email.includes('@')) {
            showToast('Thank you for subscribing! Check your inbox soon.', 'success');
            document.getElementById('newsEmail').value = '';
        } else {
            showToast('Please enter a valid email address.', 'warning');
        }
    }

    // Modern Toast Notification (Fixed JSP EL Conflict)
    function showToast(message, type = 'info') {
        const container = document.body;
        const toast = document.createElement('div');
        
        toast.className = 'toast-dark';
        
        const icon = type === 'success' ? 'fa-circle-check' : 'fa-circle-info';
        const color = type === 'success' ? '#10b981' : '#4e73df'; // Emerald vs Primary
        
        toast.style.borderLeftColor = color;

        toast.innerHTML = '<i class="fa-solid ' + icon + ' fs-5" style="color: ' + color + '"></i>' +
                          '<span>' + message + '</span>';
                          
        container.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(20px)';
            toast.style.transition = '0.5s';
            setTimeout(() => toast.remove(), 500);
        }, 4000);
    }

    // Scroll to top visibility
    window.onscroll = function() {
        const btn = document.getElementById("backToTop");
        if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
            btn.style.display = "flex";
        } else {
            btn.style.display = "none";
        }
    };
</script>
</body>
</html>