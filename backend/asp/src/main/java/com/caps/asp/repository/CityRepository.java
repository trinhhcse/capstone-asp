package com.caps.asp.repository;

import com.caps.asp.model.TbCity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CityRepository extends JpaRepository<TbCity, Integer> {
    TbCity findByNameLike(String cityName);
}
