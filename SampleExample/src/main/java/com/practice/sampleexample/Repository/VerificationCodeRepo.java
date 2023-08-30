package com.practice.sampleexample.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.practice.sampleexample.Model.VerificationCode;


public interface VerificationCodeRepo extends JpaRepository<VerificationCode,Long> {
    
    void deleteByEmail(String email);

    VerificationCode findByEmail(String email);
}
