package com.elearn.service;

import com.elearn.model.PayoutRequest;
import com.elearn.model.enums.PayoutStatus;
import com.elearn.repository.PayoutRequestRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class PayoutService {

    private final PayoutRequestRepository payoutRepository;

    // Admin ke liye saari requests laana
    @Transactional(readOnly = true)
    public List<PayoutRequest> getAllRequests() {
        return payoutRepository.findAll();
    }

    // Admin jab paise bhej de toh status PAID karna
    public void approvePayout(Long id) {
        PayoutRequest request = payoutRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payout request not found"));
        request.setStatus(PayoutStatus.PAID);
        payoutRepository.save(request);
    }

    // Agar request reject karni ho
    public void rejectPayout(Long id) {
        PayoutRequest request = payoutRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payout request not found"));
        request.setStatus(PayoutStatus.REJECTED);
        payoutRepository.save(request);
    }
}