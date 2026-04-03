package com.elearn.service;

import com.elearn.model.User;
import com.elearn.model.VerificationToken;
import com.elearn.repository.VerificationTokenRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional
public class VerificationTokenService {

    private final VerificationTokenRepository tokenRepository;

    @Value("${app.token.expiry.hours:24}")
    private int tokenExpiryHours;

    public String createToken(User user) {

        // Purana unused token delete karo — deleteByUsedTrue() nahi,
        // findByUserIdAndUsedFalse use karke manually delete karo
        tokenRepository.findByUserIdAndUsedFalse(user.getId())
                .ifPresent(old -> tokenRepository.delete(old));

        String tokenValue = UUID.randomUUID().toString();

        // builder() ki jagah new + setters use karo
        VerificationToken token = new VerificationToken();
        token.setToken(tokenValue);
        token.setUser(user);
        token.setExpiresAt(
            LocalDateTime.now().plusHours(tokenExpiryHours));
        token.setUsed(false);

        tokenRepository.save(token);
        return tokenValue;
    }

    @Transactional(readOnly = true)
    public VerificationToken getToken(String tokenValue) {
        return tokenRepository.findByToken(tokenValue)
                .orElseThrow(() -> new RuntimeException(
                        "Invalid verification token"));
    }

    public void markTokenUsed(VerificationToken token) {
        token.setUsed(true);
        tokenRepository.save(token);
    }
}