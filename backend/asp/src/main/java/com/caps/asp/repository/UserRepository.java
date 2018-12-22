package com.caps.asp.repository;

import com.caps.asp.model.TbUser;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<TbUser, Integer> {

    TbUser findByUsername(String username);
    TbUser findByUserId(int id);
    TbUser findByUsernameAndPassword(String username, String password);
    TbUser findByEmail(String email);
    Page<TbUser> findAll(Pageable pageable);
}
