package com.caps.asp.service;

import com.caps.asp.model.TbDistrictReference;
import com.caps.asp.repository.DistrictReferenceRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class DistrictReferenceService {

    public final DistrictReferenceRepository districtReferenceRepository;

    public DistrictReferenceService(DistrictReferenceRepository districtReferenceRepository) {
        this.districtReferenceRepository = districtReferenceRepository;
    }

    public List<TbDistrictReference> findAllByUserId(int userId){
        return districtReferenceRepository.findAllByUserId(userId);
    }

    public void removeAllByUserId(int userid){
        districtReferenceRepository.removeAllByUserId(userid);
    }

    public void save(TbDistrictReference tbDistrictReference){
        districtReferenceRepository.save(tbDistrictReference);
    }
}
