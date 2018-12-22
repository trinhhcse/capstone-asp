package com.caps.asp.service;

import com.caps.asp.model.TbDistrict;
import com.caps.asp.repository.DistrictRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class DistrictService {

    public final DistrictRepository districtRepository;

    public DistrictService(DistrictRepository districtRepository) {
        this.districtRepository = districtRepository;
    }

    public List<TbDistrict>findAll(){
        return districtRepository.findAll();
    }

    public List<TbDistrict>findAllByCity(int cityId){
        return districtRepository.findAllByCityId(cityId);
    }

    public TbDistrict findByDistrictId(int districtId){
        return districtRepository.findByDistrictId(districtId);
    }

    public TbDistrict findByNameLikeAndDistrictId(String districtName, int cityId){
        return districtRepository.findByNameLikeAndCityId(districtName, cityId);
    }
}
