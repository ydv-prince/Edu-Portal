package com.elearn.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${app.base-url}")
    private String baseUrl;

    @Value("${app.email.from}")
    private String fromEmail;

    // ── OTP Verification Email ──

    public void sendOtpEmail(String toEmail, String userName, String otp) {
        String subject = "🔐 Verify Your Account - OTP: " + otp;
        String body = """
                <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px;">
                    <div style="text-align: center; margin-bottom: 20px;">
                        <h2 style="color: #4F46E5; margin-bottom: 5px;">E-Learn Platform</h2>
                        <p style="color: #64748b; font-size: 14px;">Building the future of learning</p>
                    </div>
                    <p>Hi <strong>%s</strong>,</p>
                    <p>Thank you for joining E-Learn! Please use the following One-Time Password (OTP) to verify your email address:</p>
                    <div style="text-align: center; margin: 30px 0;">
                        <div style="display: inline-block; background-color: #f1f5f9; border: 2px dashed #4F46E5; color: #1e1b4b; 
                                    padding: 15px 40px; border-radius: 8px; font-size: 32px; font-weight: 800; letter-spacing: 5px;">
                            %s
                        </div>
                    </div>
                    <p style="color: #ef4444; font-size: 14px; font-weight: 600;">Note: This OTP is valid for 10 minutes only.</p>
                    <hr style="border: 0; border-top: 1px solid #e2e8f0; margin: 20px 0;">
                    <p style="color: #94a3b8; font-size: 12px; text-align: center;">&copy; 2026 E-Learn Inc. All rights reserved.</p>
                </div>
                """.formatted(userName, otp);

        sendHtmlEmail(toEmail, subject, body);
    }

    // ── Enrollment Confirmation Email ──
    @Async
    public void sendEnrollmentEmail(String toEmail, String userName, String courseName) {
        String subject = "🎉 Enrollment Confirmed: " + courseName;
        String body = """
                <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px;">
                    <h2 style="color: #10B981;">Enrollment Successful!</h2>
                    <p>Hello <strong>%s</strong>,</p>
                    <p>You have successfully enrolled in the course: <strong>%s</strong>.</p>
                    <p>You can now access your learning materials and start building your skills immediately.</p>
                    <div style="text-align: center; margin: 30px 0;">
                        <a href="%s/student/my-courses"
                           style="background-color: #10B981; color: white; padding: 14px 28px; text-decoration: none; border-radius: 6px; font-weight: 600; display: inline-block;">
                           Go to My Courses
                        </a>
                    </div>
                </div>
                """.formatted(userName, courseName, baseUrl);

        sendHtmlEmail(toEmail, subject, body);
    }

    // ── Certificate Email ──
    @Async
    public void sendCertificateEmail(String toEmail, String userName, String courseName, String certificateUrl) {
        String subject = "🏆 Certificate Ready — " + courseName;
        String body = """
                <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px;">
                    <h2 style="color: #F59E0B;">Congratulations! 🎓</h2>
                    <p>Hi <strong>%s</strong>,</p>
                    <p>You have successfully completed the course: <strong>%s</strong>!</p>
                    <p>Your hard work has paid off. Your official certificate is now available for download.</p>
                    <div style="text-align: center; margin: 30px 0;">
                        <a href="%s" 
                           style="background-color: #F59E0B; color: white; padding: 14px 28px; 
                                  text-decoration: none; border-radius: 6px; font-weight: bold; display: inline-block;">
                            Download Certificate
                        </a>
                    </div>
                    <p style="color: #64748b; font-size: 13px;">Keep learning and growing!</p>
                </div>
                """.formatted(userName, courseName, certificateUrl);

        sendHtmlEmail(toEmail, subject, body);
    }

    // ── Password Reset Email ──
    @Async
    public void sendPasswordResetEmail(String toEmail, String userName, String otp) {
        String subject = "🔐 Password Reset OTP: " + otp;
        String body = """
                <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px;">
                    <h2 style="color: #EF4444;">Reset Your Password</h2>
                    <p>Hi <strong>%s</strong>,</p>
                    <p>We received a request to reset your E-Learn account password. Use the code below to proceed:</p>
                    <div style="text-align: center; margin: 30px 0;">
                        <span style="font-size: 28px; font-weight: bold; background: #fee2e2; color: #991b1b; padding: 10px 30px; border-radius: 8px; letter-spacing: 5px;">
                            %s
                        </span>
                    </div>
                    <p style="color: #64748b; font-size: 14px;">Valid for 15 minutes. If you didn't request this, please secure your account.</p>
                </div>
                """.formatted(userName, otp);

        sendHtmlEmail(toEmail, subject, body);
    }

    // ── Generic HTML Email Sender ──
    private void sendHtmlEmail(String to, String subject, String htmlBody) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlBody, true);
            mailSender.send(message);
            log.info("✅ Email successfully sent to {}", to);
        } catch (MessagingException e) {
            log.error("❌ Email delivery failed to {}: {}", to, e.getMessage());
        }
    }
}