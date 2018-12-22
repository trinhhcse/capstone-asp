package com.caps.asp.repository;

import com.caps.asp.model.TbReference;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReferenceRepository extends JpaRepository<TbReference, Integer> {

    TbReference findByUserId(int userId);
    void removeByUserId(int userid);
}
