package com.caps.asp.repository;

import com.caps.asp.model.TbDistrictReference;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DistrictReferenceRepository extends JpaRepository<TbDistrictReference,Integer> {

    List<TbDistrictReference> findAllByUserId(int userId);
    void removeAllByUserId(int userId);
}
