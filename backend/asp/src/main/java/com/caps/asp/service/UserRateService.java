package com.caps.asp.service;

import com.caps.asp.model.TbUserRate;
import com.caps.asp.repository.UserRateRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserRateService {
    public UserRateRepository userRateRepository;

    public UserRateService(UserRateRepository userRateRepository) {
        this.userRateRepository = userRateRepository;
    }

    public TbUserRate findByUserIdAndOwnerId(int userId, int ownerId) {
        return userRateRepository.findByUserIdAndOwnerId(userId, ownerId);
    }

    public void saveUserRate(TbUserRate userRate) {
        userRateRepository.saveAndFlush(userRate);
    }

    public Page<TbUserRate> findAllByUserId(int userId, int page, int offset) {
        int actualPage = page - 1;
        Pageable pageable = PageRequest.of(actualPage, offset);
        return userRateRepository.findAllByUserIdOrderByDateDesc(userId, pageable);
    }

    public List<TbUserRate> findAllByUserId(int userId) {
        return userRateRepository.findAllByUserId(userId);
    }

    public List<TbUserRate> findAllByUserIdOrderByDateDesc(int userId) {
        return userRateRepository.findAllByUserIdOrderByDateDesc(userId);
    }
    public Page<TbUserRate> findAllByUserIdOrderByDateDesc(int userId, Pageable pageable) {
        return userRateRepository.findAllByUserIdOrderByDateDesc(userId,pageable);
    }
}
