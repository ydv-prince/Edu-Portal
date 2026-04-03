package com.elearn.controller;

import com.elearn.model.Course;
import com.elearn.model.Payment;
import com.elearn.model.PayoutRequest;
import com.elearn.model.Review;
import com.elearn.model.SupportTicket;
import com.elearn.model.User;
import com.elearn.model.enums.Role;
import com.elearn.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
@RequiredArgsConstructor
@Slf4j
public class AdminController {

    private final UserService userService;
    private final CourseService courseService;
    private final PaymentService paymentService;
    private final EnrollmentService enrollmentService;
    private final CategoryService categoryService;
    private final ReviewService reviewService;
    private final SupportTicketService supportTicketService;
    private final PayoutService payoutService;

    // ── Global Attributes (Zaroori for Navbar) ──
    @ModelAttribute
    public void addGlobalAttributes(Model model, @AuthenticationPrincipal UserDetails ud) {
        if (ud != null) {
            User admin = userService.getUserByEmail(ud.getUsername());
            model.addAttribute("admin", admin);
        }
    }

    // ── 1. Admin Dashboard ──
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        // Stats for Dashboard Cards
        model.addAttribute("totalUsers", userService.getAllUsers().size());
        
        // ✅ Yahan error fix kar diya gaya hai
        model.addAttribute("totalCourses", courseService.getAllPublishedCourses().size());
        
        model.addAttribute("platformRevenue", 0); // Replace with paymentService method later
        model.addAttribute("pendingPayouts", 0);

        // Fetch Recent Activity Data
        List<User> allUsers = userService.getAllUsers();
        
        // ✅ Yahan bhi error fix kar diya gaya hai
        List<Course> allCourses = courseService.getAllPublishedCourses();

        java.util.Collections.reverse(allUsers);
        java.util.Collections.reverse(allCourses);
        
        model.addAttribute("recentUsers", allUsers.stream().limit(5).toList());
        model.addAttribute("recentCourses", allCourses.stream().limit(5).toList());

        return "admin/dashboard";
    }

    // ── 2. Manage Users ──
    @GetMapping("/manage-users") 
    public String manageUsers(@RequestParam(required = false) String role, Model model) {
        List<User> users;
        if (role != null && !role.isBlank()) {
            users = userService.getUsersByRole(Role.valueOf(role.toUpperCase()));
            model.addAttribute("selectedRole", role);
        } else {
            users = userService.getAllUsers();
        }
        model.addAttribute("users", users);
        return "admin/manage-users";
    }

    @PostMapping("/users/{userId}/toggle-status")
    public String toggleUserStatus(@PathVariable Long userId, RedirectAttributes ra) {
        userService.toggleUserStatus(userId);
        ra.addFlashAttribute("successMsg", "User status updated successfully!");
        return "redirect:/admin/manage-users"; 
    }

    @PostMapping("/users/{userId}/delete")
    public String deleteUser(@PathVariable Long userId, RedirectAttributes ra) {
        userService.deleteUser(userId);
        ra.addFlashAttribute("successMsg", "User has been removed from the platform.");
        return "redirect:/admin/manage-users"; 
    }

    // ── 3. Category Management ──
    @GetMapping("/manage-categories") 
    public String manageCategories(Model model) {
        model.addAttribute("categories", categoryService.getAllCategories());
        return "admin/manage-categories"; 
    }

    @PostMapping("/categories/add")
    public String addCategory(@RequestParam String name, @RequestParam(required = false) String description, RedirectAttributes ra) {
        try {
            categoryService.createCategory(name, description, null); // Ya jo bhi method aapke service mein ho
            ra.addFlashAttribute("successMsg", "New category added successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed to add category.");
        }
        return "redirect:/admin/manage-categories"; 
    }

    @PostMapping("/categories/update/{id}")
    public String updateCategory(@PathVariable Long id, @RequestParam String name, @RequestParam String description, RedirectAttributes ra) {
        categoryService.updateCategory(id, name, description);
        ra.addFlashAttribute("successMsg", "Category updated successfully!");
        return "redirect:/admin/manage-categories";
    }

    @PostMapping("/categories/delete/{id}")
    public String deleteCategory(@PathVariable Long id, RedirectAttributes ra) {
        categoryService.deleteCategory(id);
        ra.addFlashAttribute("successMsg", "Category deleted successfully!");
        return "redirect:/admin/manage-categories";
    }

    
    
 // ── 4. Course Management ──
 // ── 4. Course Management (Updated with Debugging) ──
    @GetMapping("/manage-courses")
    public String manageCourses(@RequestParam(required = false) String filter, Model model) {
        log.info("Admin accessing manage-courses with filter: {}", filter);
        
        try {
            List<Course> courses;
            if ("pending".equals(filter)) {
                courses = courseService.getPendingApprovalCourses(); 
            } else {
                courses = courseService.getAllPublishedCourses();
            }
            
            // Debugging: Console mein check karein ki data aa raha hai ya nahi
            System.out.println("Courses fetched: " + (courses != null ? courses.size() : "null"));
            
            model.addAttribute("courses", courses);
            model.addAttribute("filter", filter);
            
            return "admin/manage-courses"; 
            
        } catch (Exception e) {
            log.error("Error in manage-courses: ", e);
            // Agar JSP load nahi ho raha, toh ye error browser mein dikhega
            return "error"; 
        }
    }

    @GetMapping("/profile")
    public String showAdminProfile(Model model, Principal principal) {
        // Current logged in user ka email nikalne ke liye
        String email = principal.getName();
        
        // Database se user ki poori details fetch karein
        User currentUser = userService.findByEmail(email);
        
        // JSP ko data bhejne ke liye
        model.addAttribute("user", currentUser); // profile.jsp is 'user' object ko use karegi
        model.addAttribute("admin", currentUser); // Navbar ke liye
        
        // Aapka file path: WEB-INF/views/common/profile.jsp
        // Agar prefix/suffix set hai toh sirf "common/profile" likhein
        return "common/profile"; 
    }
    @PostMapping("/courses/{courseId}/approve")
    public String approveCourse(@PathVariable Long courseId, RedirectAttributes ra) {
        courseService.approveCourse(courseId); // Agar method hai to
        ra.addFlashAttribute("successMsg", "Course has been approved!");
        return "redirect:/admin/manage-courses";
    }
    
    @GetMapping("/manage-payments")
    public String managePayments(Model model) {
        // Jab Payment Service puri ban jayegi tab isko uncomment karenge
         List<Payment> payments = paymentService.getAllPayments();
         model.addAttribute("payments", payments);
        return "admin/manage-payments";
    }
 // ── Payout Requests ──
    @GetMapping("/payout-requests")
    public String payoutRequests(Model model) {
        List<PayoutRequest> requests = payoutService.getAllRequests();
        model.addAttribute("payoutRequests", requests);
        return "admin/payout-requests";
    }

    @PostMapping("/payouts/{id}/approve")
    public String approvePayout(@PathVariable Long id, RedirectAttributes ra) {
        payoutService.approvePayout(id);
        ra.addFlashAttribute("successMsg", "Payout marked as Paid successfully!");
        return "redirect:/admin/payout-requests";
    }

    @PostMapping("/payouts/{id}/reject")
    public String rejectPayout(@PathVariable Long id, RedirectAttributes ra) {
        payoutService.rejectPayout(id);
        ra.addFlashAttribute("errorMsg", "Payout request rejected.");
        return "redirect:/admin/payout-requests";
    }
    
 // ── 5. Settings ──
    @GetMapping("/settings")
    public String settings(Model model) {
        // Platform settings jaise commission rate abhi static JSPs mein hain. 
        // Future mein ise database se fetch kiya ja sakta hai.
        return "admin/settings";
    }

    @PostMapping("/settings/update-platform")
    public String updatePlatformSettings(RedirectAttributes ra) {
        // Logic for updating global settings will go here
        ra.addFlashAttribute("successMsg", "Platform settings updated successfully!");
        return "redirect:/admin/settings";
    }

    @PostMapping("/settings/update-password")
    public String updateAdminPassword(RedirectAttributes ra) {
        // Logic for updating password will go here
        ra.addFlashAttribute("successMsg", "Security settings updated!");
        return "redirect:/admin/settings";
    }
 // ── 6. Support Tickets ──
    @GetMapping("/support-tickets")
    public String supportTickets(@RequestParam(required = false) String status, Model model) {
        List<SupportTicket> tickets;
        
        // ✅ Yahan 'supportTicketService' use kiya hai
        if (status != null && !status.isBlank()) {
            tickets = supportTicketService.getTicketsByStatus(status);
        } else {
            tickets = supportTicketService.getAllTickets();
        }
        
        model.addAttribute("tickets", tickets);
        return "admin/support-tickets";
    }

    @PostMapping("/support-tickets/{id}/resolve")
    public String resolveTicket(@PathVariable Long id, RedirectAttributes ra) {
        
        // ✅ Yahan bhi 'supportTicketService' use kiya hai
        supportTicketService.resolveTicket(id);
        
        ra.addFlashAttribute("successMsg", "Support ticket has been marked as resolved!");
        return "redirect:/admin/support-tickets";
    }

    
 // ── 7. Course Reviews ──
    @GetMapping("/manage-reviews")
    public String manageReviews(Model model) {
        // Jab Review Service ban jayegi, tab list yahan se jayegi
        List<Review> reviews = reviewService.getAllReviews();
        model.addAttribute("reviews", reviews);
        return "admin/manage-reviews";
    }

    @PostMapping("/manage-reviews/{id}/delete")
    public String deleteReview(@PathVariable Long id, RedirectAttributes ra) {
        // reviewService.deleteReview(id);
        ra.addFlashAttribute("successMsg", "Review deleted successfully.");
        return "redirect:/admin/manage-reviews";
    }
    
 // ── 8. Analytics & Reports ──
    @GetMapping("/analytics")
    public String analytics(Model model) {
        // Stats
        model.addAttribute("totalStudents", userService.countByRole(Role.STUDENT));
        model.addAttribute("totalTeachers", userService.countByRole(Role.TEACHER));
        model.addAttribute("categories", categoryService.getAllCategories());
        
        // Payment Service banne ke baad isme logic lagayenge
        int currentYear = java.time.LocalDate.now().getYear();
        model.addAttribute("monthlyRevenue", paymentService.getMonthlyRevenue(currentYear));
        model.addAttribute("totalRevenue", 0); // Placeholder
        
        return "admin/analytics";
    }
}