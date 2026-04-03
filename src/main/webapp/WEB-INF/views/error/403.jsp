<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Access Denied"/>


<div class="text-center py-5 my-5">
    <div style="
        font-size:5rem;font-weight:800;
        color:#e74a3b;line-height:1;">
        403
    </div>
    <h4 style="color:white;margin-top:12px;">
        Access Denied
    </h4>
    <p style="color:rgba(255,255,255,0.45);margin:12px 0 24px;">
        Aapke paas yeh page dekhne ka permission nahi hai.
    </p>
    <h1>Rahul</h1>
    <a href="${pageContext.request.contextPath}/"
       style="
        display:inline-flex;align-items:center;gap:8px;
        background:linear-gradient(135deg,#4e73df,#224abe);
        color:white;font-weight:700;padding:12px 24px;
        border-radius:10px;text-decoration:none;">
        <i class="fa-solid fa-home"></i>
        Home Par Jao
    </a>
</div>


```

---

## 🎯 Ab yeh steps follow karo:

### Step 1 — Eclipse mein Maven Update
```
Project pe Right Click
→ Maven
→ Update Project
→ Force Update: ✅ CHECK KARO
→ OK
```

### Step 2 — Clean Build
```
Project
→ Clean
→ OK
```

### Step 3 — Run
```
ElearnApplication.java pe Right Click
→ Run As
→ Spring Boot App
```

### Step 4 — Browser
```
http://localhost:8081/
```

---

## 🔍 Console mein yeh lines dhundho:
```
# ✅ SAHI hoga agar:
Tomcat started on port(s): 8081
Started ElearnApplication in X seconds
Mapped "{[/],[/home]}" onto public String homePage

# ❌ GALAT hai agar:
No mapping for GET /
Cannot find template location: classpath:/templates/