package com.caps.asp.service;

import com.caps.asp.model.TbUtilitiesReference;
import com.caps.asp.repository.UtilityReferenceRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class UtilityReferenceService {

    public final UtilityReferenceRepository utilityReferenceRepository;

    public UtilityReferenceService(UtilityReferenceRepository utilityReferenceRepository) {
        this.utilityReferenceRepository = utilityReferenceRepository;
    }

    public List<TbUtilitiesReference> findAllByUserId(int userId){
        return utilityReferenceRepository.findAllByUserId(userId);
    }

    public void removeAllByUserId(int userId){
        utilityReferenceRepository.removeAllByUserId(userId);
    }

    public void save(TbUtilitiesReference utilitiesReference){
        utilityReferenceRepository.save(utilitiesReference);
    }
}
