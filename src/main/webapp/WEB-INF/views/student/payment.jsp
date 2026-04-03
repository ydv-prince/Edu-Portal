<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Secure Checkout"/>
<%@ include file="../common/header.jsp" %>

<style>
    :root {
        --bg-dark: #020617;
        --surface: rgba(15, 23, 42, 0.7);
        --primary: #6366f1;
        --accent: #a855f7;
        --emerald: #10b981;
        --text-dim: #94a3b8;
        --glass-border: rgba(255, 255, 255, 0.08);
    }

    body { background-color: var(--bg-dark); color: #f8fafc; overflow-x: hidden; }

    /* ── Ambient Background Glow ── */
    .checkout-glow {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: radial-gradient(circle at 50% -20%, rgba(99, 102, 241, 0.05) 0%, transparent 70%);
        z-index: -1; pointer-events: none;
    }

    .glass-card { 
        background: var(--surface); backdrop-filter: blur(16px); 
        border: 1px solid var(--glass-border); border-radius: 24px; 
        box-shadow: 0 25px 50px rgba(0,0,0,0.3);
    }

    .payment-card {
        background: rgba(255, 255, 255, 0.02); border: 1px solid rgba(255, 255, 255, 0.05);
        border-radius: 16px; padding: 20px; cursor: pointer; transition: 0.3s; height: 100%;
    }
    .payment-card:hover { border-color: rgba(99, 102, 241, 0.4); background: rgba(99, 102, 241, 0.05); transform: translateY(-3px); }
    .payment-card.selected { border-color: var(--primary); background: rgba(99, 102, 241, 0.1); box-shadow: 0 10px 25px rgba(99, 102, 241, 0.2); }
    
    .payment-logo { width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; background: rgba(255,255,255,0.05); }

    .form-control-dark {
        background: rgba(0,0,0,0.3); border: 1.5px solid var(--glass-border);
        border-radius: 14px; padding: 14px 18px; color: white; transition: 0.3s; font-family: monospace; font-size: 1.1rem;
    }
    .form-control-dark:focus { border-color: var(--primary); outline: none; background: rgba(0,0,0,0.5); box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1); }
    .form-control-dark::placeholder { color: rgba(255,255,255,0.2); }

    .btn-pay {
        background: var(--primary); color: white; padding: 16px; border-radius: 16px;
        font-weight: 800; border: none; transition: 0.3s; width: 100%; font-size: 1.1rem;
        display: flex; align-items: center; justify-content: center; gap: 10px;
    }
    .btn-pay:hover { transform: translateY(-3px); background: #4f46e5; box-shadow: 0 15px 30px rgba(99, 102, 241, 0.4); color: white; }
    
    .btn-back {
        background: rgba(255,255,255,0.03); color: var(--text-dim); border: 1px solid var(--glass-border);
        padding: 8px 16px; border-radius: 10px; font-weight: 700; font-size: 0.85rem;
        transition: 0.3s; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-back:hover { background: rgba(255,255,255,0.1); color: white; transform: translateX(-3px); }

    /* ── Animations ── */
    @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    .animate-fade { animation: fadeInUp 0.5s ease-out forwards; opacity: 0; }
    .delay-1 { animation-delay: 0.1s; }
    .delay-2 { animation-delay: 0.2s; }
</style>

<div class="checkout-glow"></div>

<div class="container py-4 py-lg-5">
    <div class="row justify-content-center">
        <div class="col-xl-10">
            
            <%-- Back Navigation --%>
            <div class="mb-4 animate-fade">
                <a href="${pageContext.request.contextPath}/student/course-detail/${course.id}" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Cancel & Return
                </a>
            </div>

            <div class="text-center mb-5 animate-fade">
                <h2 class="text-white fw-900 display-6 mb-2">Secure Checkout</h2>
                <p class="text-dim"><i class="fa-solid fa-shield-check me-2 text-emerald"></i> 256-bit SSL Encrypted Transaction</p>
            </div>

            <div class="row g-4 g-lg-5">
                
                <%-- LEFT: Payment Details --%>
                <div class="col-lg-7 animate-fade delay-1">
                    <div class="glass-card p-4 p-md-5 mb-4">
                        <div class="d-flex align-items-center gap-3 mb-5 pb-4 border-bottom border-white-50 border-opacity-10">
                            <div class="bg-primary p-3 rounded-4 text-white shadow-sm">
                                <i class="fa-solid fa-graduation-cap fs-4"></i>
                            </div>
                            <div>
                                <div class="text-primary fw-800 small text-uppercase mb-1" style="letter-spacing: 1px;">Course Enrollment</div>
                                <h5 class="text-white fw-900 m-0" style="line-height: 1.4;">${course.title}</h5>
                            </div>
                        </div>

                        <label class="text-dim fw-800 small mb-3 text-uppercase" style="letter-spacing: 1px;">Select Payment Method</label>
                        <div class="row g-3 mb-5">
                            <div class="col-sm-6">
                                <div class="payment-card selected" onclick="selectPayment('upi', this)">
                                    <div class="payment-logo text-warning"><i class="fa-solid fa-bolt"></i></div>
                                    <div class="fw-800 text-white mt-3">UPI / Instant Pay</div>
                                    <div class="text-dim x-small fw-600 mt-1">GPay, PhonePe, Paytm</div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="payment-card" onclick="selectPayment('card', this)">
                                    <div class="payment-logo text-primary"><i class="fa-solid fa-credit-card"></i></div>
                                    <div class="fw-800 text-white mt-3">Credit / Debit Card</div>
                                    <div class="text-dim x-small fw-600 mt-1">Visa, Mastercard, RuPay</div>
                                </div>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/student/payment/process" method="post" id="paymentForm">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="courseId" value="${course.id}"/>
                            <input type="hidden" name="amount" value="${course.discountPrice != null && course.discountPrice > 0 ? course.discountPrice : course.price}"/>
                            
                            <div id="cardSection" style="display:none;" class="animate-fade">
                                <div class="mb-4">
                                    <label class="text-dim small fw-800 mb-2 text-uppercase" style="letter-spacing: 1px;">Card Number</label>
                                    <input type="text" class="form-control-dark w-100" placeholder="0000 0000 0000 0000" oninput="formatCard(this)" maxlength="19">
                                </div>
                                <div class="row g-3 mb-5">
                                    <div class="col-6">
                                        <label class="text-dim small fw-800 mb-2 text-uppercase" style="letter-spacing: 1px;">Expiry Date</label>
                                        <input type="text" class="form-control-dark w-100" placeholder="MM / YY" oninput="formatExpiry(this)" maxlength="7">
                                    </div>
                                    <div class="col-6">
                                        <label class="text-dim small fw-800 mb-2 text-uppercase" style="letter-spacing: 1px;">CVV</label>
                                        <input type="password" class="form-control-dark w-100" placeholder="***" maxlength="3">
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="btn-pay shadow-lg" id="payBtn">
                                <i class="fa-solid fa-bolt text-warning"></i> Pay ₹<c:out value="${course.discountPrice != null && course.discountPrice > 0 ? course.discountPrice : course.price}"/> Securely
                            </button>
                        </form>
                    </div>
                </div>

                <%-- RIGHT: Order Summary --%>
                <div class="col-lg-5 animate-fade delay-2">
                    <div class="glass-card p-4 p-md-5 sticky-top" style="top: 100px;">
                        <h5 class="text-white fw-900 mb-4 pb-3 border-bottom border-white-50 border-opacity-10">Order Summary</h5>
                        
                        <div class="d-flex justify-content-between mb-3">
                            <span class="text-dim fw-600">Original Price</span>
                            <span class="text-white fw-bold">₹${course.price}</span>
                        </div>

                        <c:if test="${course.discountPrice != null && course.discountPrice > 0 && course.price > course.discountPrice}">
                            <div class="d-flex justify-content-between mb-3">
                                <span class="text-emerald fw-600">Platform Discount</span>
                                <span class="text-emerald fw-800">- ₹${course.price - course.discountPrice}</span>
                            </div>
                        </c:if>

                        <div class="d-flex justify-content-between mb-4">
                            <span class="text-dim fw-600">Taxes & Processing Fees</span>
                            <span class="text-white fw-bold">₹0.00</span>
                        </div>

                        <div class="p-4 rounded-4 mb-4" style="background: rgba(99, 102, 241, 0.1); border: 1px solid rgba(99, 102, 241, 0.2);">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-white fw-800 text-uppercase" style="letter-spacing: 1px;">Total Amount</span>
                                <span class="display-6 text-primary fw-900 m-0">
                                    ₹<c:out value="${course.discountPrice != null && course.discountPrice > 0 ? course.discountPrice : course.price}"/>
                                </span>
                            </div>
                        </div>

                        <div class="bg-emerald bg-opacity-10 p-3 rounded-4 border border-success border-opacity-25 mb-4">
                            <div class="d-flex align-items-center gap-3">
                                <i class="fa-solid fa-shield-check text-emerald fs-3"></i>
                                <div>
                                    <div class="text-emerald fw-800 small mb-1">30-Day Guarantee</div>
                                    <p class="text-dim" style="font-size: 0.7rem; margin: 0; line-height: 1.4;">Full refund if you're not 100% satisfied with the course content.</p>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex flex-column gap-2 mt-4">
                            <div class="text-dim small fw-600"><i class="fa-solid fa-infinity text-primary me-2"></i> Full lifetime access included</div>
                            <div class="text-dim small fw-600"><i class="fa-solid fa-certificate text-warning me-2"></i> Verified completion certificate</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const finalAmount = '${course.discountPrice != null && course.discountPrice > 0 ? course.discountPrice : course.price}';

    function selectPayment(method, el) {
        document.querySelectorAll('.payment-card').forEach(c => c.classList.remove('selected'));
        el.classList.add('selected');
        
        const cardSection = document.getElementById('cardSection');
        const payBtn = document.getElementById('payBtn');
        
        if(method === 'card') {
            cardSection.style.display = 'block';
            payBtn.innerHTML = '<i class="fa-solid fa-lock text-white-50"></i> Pay ₹' + finalAmount + ' Securely';
        } else {
            cardSection.style.display = 'none';
            payBtn.innerHTML = '<i class="fa-solid fa-bolt text-warning"></i> Pay ₹' + finalAmount + ' via UPI';
        }
    }

    function formatCard(input) {
        let v = input.value.replace(/\D/g, '').substring(0, 16);
        input.value = v.replace(/(.{4})/g, '$1 ').trim();
    }

    function formatExpiry(input) {
        let v = input.value.replace(/\D/g, '');
        if (v.length >= 2) v = v.substring(0, 2) + ' / ' + v.substring(2, 4);
        input.value = v;
    }

    document.getElementById('paymentForm').addEventListener('submit', function(e) {
        const btn = document.getElementById('payBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fa-solid fa-circle-notch fa-spin me-2"></i> Processing Secure Payment...';
    });
</script>

<%@ include file="../common/footer.jsp" %>