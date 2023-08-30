package com.practice.sampleexample.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.practice.sampleexample.Model.User;

public interface UserRepository extends JpaRepository<User, Long> {
    
    @Query("SELECT CASE WHEN COUNT(u) > 0 THEN true ELSE false END FROM User u WHERE u.email = ?1")
    boolean existsByEmail(String email);

    User findByEmail(String email);
}
