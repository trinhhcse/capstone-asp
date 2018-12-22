package com.caps.asp.repository;

import com.caps.asp.model.TbUserRate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserRateRepository extends JpaRepository<TbUserRate, Integer> {
    TbUserRate findByUserIdAndOwnerId(Integer userId, Integer ownerId);
    List<TbUserRate> findAllByUserId(int userId);
    Page<TbUserRate> findAllByUserIdOrderByDateDesc(int userId, Pageable pageable);
    List<TbUserRate> findAllByUserIdOrderByDateDesc(int userId);
}
