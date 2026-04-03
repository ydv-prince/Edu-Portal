package com.elearn.repository;

import com.elearn.model.VerificationToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface VerificationTokenRepository
        extends JpaRepository<VerificationToken, Long> {

    Optional<VerificationToken> findByToken(String token);

    // ← User ke active token dhundho
    Optional<VerificationToken> findByUserIdAndUsedFalse(Long userId);

    // ← Used tokens cleanup
    void deleteByUsedTrue();

    // ← deleteByUser remove kiya — replace kiya
    //    findByUserIdAndUsedFalse se
}