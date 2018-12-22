package com.caps.asp.repository;

import com.caps.asp.model.TbUtilitiesReference;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UtilityReferenceRepository extends JpaRepository<TbUtilitiesReference, Integer> {

    List<TbUtilitiesReference> findAllByUserId(int userId);

    void removeAllByUserId(int userId);
}
