<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | E-Learn</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-dark: #070b14;
            --surface: #111827;
            --primary: #6366f1;
            --border: rgba(255, 255, 255, 0.08);
            --text-main: #f8fafc;
            --text-dim: #94a3b8;
        }

        body { background-color: var(--bg-dark); color: var(--text-main); font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }
        
        /* Navbar */
        .portal-nav { background: rgba(7, 11, 20, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; }

        /* Profile Header */
        .profile-cover { height: 160px; background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border-radius: 24px 24px 0 0; }
        
        .profile-card { background: white !important; border-radius: 24px; overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.3); border: none; margin-top: -80px; }
        
        .avatar-container { position: relative; width: 120px; height: 120px; margin-left: 40px; }
        .profile-avatar { width: 120px; height: 120px; border-radius: 30px; border: 5px solid white; object-fit: cover; background: #e0e7ff; display: flex; align-items: center; justify-content: center; font-size: 3rem; font-weight: 800; color: var(--primary); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        
        .upload-btn { position: absolute; bottom: -5px; right: -5px; background: var(--primary); color: white; width: 35px; height: 35px; border-radius: 10px; display: flex; align-items: center; justify-content: center; cursor: pointer; border: 3px solid white; transition: 0.3s; }
        .upload-btn:hover { transform: scale(1.1); background: #4f46e5; }

        /* Form Styling */
        .info-card { background: white !important; border-radius: 24px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); border: none; }
        .form-label { color: #475569; font-size: 0.75rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .custom-input { background: #f8fafc; border: 2px solid #e2e8f0; color: #1e293b; border-radius: 12px; padding: 12px 15px; width: 100%; transition: 0.3s; font-weight: 500; }
        .custom-input:focus { border-color: var(--primary); background: white; outline: none; }
        .custom-input:disabled { background: #f1f5f9; color: #94a3b8; cursor: not-allowed; }

        .btn-save { background: var(--primary); color: white; border-radius: 14px; padding: 12px 30px; font-weight: 700; border: none; transition: 0.3s; }
        .btn-save:hover { background: #4f46e5; transform: translateY(-2px); box-shadow: 0 10px 20px rgba(99, 102, 241, 0.2); }
    </style>
</head>
<body>

<nav class="portal-nav d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center gap-2">
        <div class="bg-primary p-2 rounded-3 text-white"><i class="fa-solid fa-graduation-cap"></i></div>
        <h4 class="m-0 fw-bold text-white">E-Learn <span class="text-primary fw-light">Profile</span></h4>
    </div>
    <a href="javascript:history.back()" class="text-dim text-decoration-none small fw-bold"><i class="fa-solid fa-arrow-left me-1"></i> Back</a>
</nav>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            
            <%-- Header Section --%>
            <div class="profile-cover shadow-lg"></div>
            <div class="profile-card mb-4">
                <div class="d-md-flex align-items-end pb-4">
                    <div class="avatar-container">
                        <c:choose>
                            <c:when test="${not empty user.profilePicture}">
                                <img src="${pageContext.request.contextPath}${user.profilePicture}" class="profile-avatar" alt="User">
                            </c:when>
                            <c:otherwise>
                                <div class="profile-avatar">${user.fullName.substring(0,1).toUpperCase()}</div>
                            </c:otherwise>
                        </c:choose>
                        <label for="pfp-upload" class="upload-btn"><i class="fa-solid fa-camera"></i></label>
                        <input type="file" id="pfp-upload" style="display: none;">
                    </div>
                    <div class="ms-md-4 mt-3 mt-md-0 mb-2">
                        <h2 class="text-dark fw-800 m-0">${user.fullName}</h2>
                        <p class="text-muted m-0 fw-bold"><i class="fa-solid fa-shield-check text-primary me-1"></i> ${user.role}</p>
                    </div>
                </div>
            </div>

            <%-- Form Section --%>
            <div class="info-card">
                <div class="d-flex align-items-center gap-2 mb-4">
                    <div style="width: 4px; height: 24px; background: var(--primary); border-radius: 10px;"></div>
                    <h5 class="m-0 text-dark fw-bold">Personal Information</h5>
                </div>

                <form action="${pageContext.request.contextPath}/profile/update" method="post">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="fullName" class="custom-input" value="${user.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email Address</label>
                            <input type="email" class="custom-input" value="${user.email}" disabled title="Email cannot be changed">
                            <p class="helper-text m-0 text-danger" style="font-size: 0.65rem;">* Account email is permanent.</p>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phone Number</label>
                            <input type="text" name="phone" class="custom-input" value="${user.phone != null ? user.phone : ''}" placeholder="+91 00000 00000">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Member Since</label>
                            <div class="custom-input bg-light">${user.createdAt.toLocalDate()}</div>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Bio / Headline</label>
                            <textarea name="bio" class="custom-input" rows="3" placeholder="Tell us about yourself...">${user.bio}</textarea>
                        </div>
                    </div>

                    <div class="mt-5 border-top pt-4 text-end">
                        <button type="submit" class="btn-save">Save Profile Changes</button>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>