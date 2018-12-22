package com.caps.asp.repository;

import com.caps.asp.model.TbDistrict;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DistrictRepository extends JpaRepository<TbDistrict, Integer> {

    List<TbDistrict> findAllByCityId(int cityId);

    TbDistrict findByDistrictId(int districtId);

    TbDistrict findByNameLikeAndCityId(String districtName, int cityId);
}
