package com.elearn.config;

import com.elearn.model.User;
import com.elearn.model.enums.Role;
import com.elearn.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class AdminSeeder implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        String adminEmail = "ry1343655@gmail.com";
        
        User existingUser = userRepository.findByEmail(adminEmail).orElse(null);
        
        if (existingUser == null) {
            User admin = new User();
            admin.setFullName("Yadav Ji Rahul");
            admin.setEmail(adminEmail);
            admin.setPassword(passwordEncoder.encode("Yadav@72")); 
            admin.setRole(Role.ADMIN);
            admin.setEnabled(true);
            admin.setEmailVerified(true);
            
            userRepository.save(admin);
            System.out.println("✅ ADMIN ACCOUNT CREATED: " + adminEmail);
        } else {
            if (existingUser.getRole() != Role.ADMIN) {
                existingUser.setRole(Role.ADMIN);
                existingUser.setEnabled(true);
                existingUser.setEmailVerified(true);
                userRepository.save(existingUser);
                System.out.println("✅ EXISTING USER PROMOTED TO ADMIN: " + adminEmail);
            } else {
                System.out.println("ℹ️ ADMIN ALREADY EXISTS IN DATABASE.");
            }
        }
    }
    
}