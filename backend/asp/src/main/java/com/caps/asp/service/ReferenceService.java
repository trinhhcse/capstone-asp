package com.caps.asp.service;

import com.caps.asp.model.TbReference;
import com.caps.asp.repository.ReferenceRepository;
import org.springframework.stereotype.Service;

@Service
public class ReferenceService {

    public final ReferenceRepository referenceRepository;

    public ReferenceService(ReferenceRepository referenceRepository) {
        this.referenceRepository = referenceRepository;
    }

    public TbReference getByUserId(int userId) {
        return referenceRepository.findByUserId(userId);
    }

    public void removeByUserId(int userId){
        referenceRepository.removeByUserId(userId);
    }

    public void save(TbReference tbReference){
        referenceRepository.save(tbReference);
    }
}
