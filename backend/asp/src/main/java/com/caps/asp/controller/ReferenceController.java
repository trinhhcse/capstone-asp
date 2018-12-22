package com.caps.asp.controller;

import com.caps.asp.model.TbDistrictReference;
import com.caps.asp.model.TbReference;
import com.caps.asp.model.TbUtilitiesReference;
import com.caps.asp.model.uimodel.request.common.SuggestSettingRequestModel;
import com.caps.asp.service.DistrictReferenceService;
import com.caps.asp.service.ReferenceService;
import com.caps.asp.service.UtilityReferenceService;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static org.springframework.http.HttpStatus.CONFLICT;
import static org.springframework.http.HttpStatus.CREATED;

@RestController
public class ReferenceController {
    public final UtilityReferenceService utilityReferenceService;
    public final DistrictReferenceService districtReferenceService;
    public final ReferenceService referenceService;

    public ReferenceController(UtilityReferenceService utilityReferenceService, DistrictReferenceService districtReferenceService, ReferenceService referenceService) {
        this.utilityReferenceService = utilityReferenceService;
        this.districtReferenceService = districtReferenceService;
        this.referenceService = referenceService;
    }

    @Transactional
    @PostMapping("/reference/save")
    public ResponseEntity createReference(@RequestBody SuggestSettingRequestModel suggestSettingRequestModel) {
        try {
            List<Double> prices = suggestSettingRequestModel.getPrice();

            TbReference checkReference = referenceService.getByUserId(suggestSettingRequestModel.getUserId());
            if (checkReference == null){
                checkReference = new TbReference();
                checkReference.setUserId(suggestSettingRequestModel.getUserId());
            }
            checkReference.setMinPrice(prices.get(0));
            checkReference.setMaxPrice(prices.get(1));
            referenceService.save(checkReference);

            utilityReferenceService.removeAllByUserId(suggestSettingRequestModel.getUserId());
            for (Integer utilityId : suggestSettingRequestModel.getUtilities()) {
                TbUtilitiesReference tbUtilitiesReference = new TbUtilitiesReference();
                tbUtilitiesReference.setId(0);
                tbUtilitiesReference.setUserId(suggestSettingRequestModel.getUserId());
                tbUtilitiesReference.setUtilityId(utilityId);
                utilityReferenceService.save(tbUtilitiesReference);
            }

            districtReferenceService.removeAllByUserId(suggestSettingRequestModel.getUserId());
            for (Integer districtId : suggestSettingRequestModel.getDistricts()) {
                TbDistrictReference tbDistrictReference = new TbDistrictReference();
                tbDistrictReference.setId(0);
                tbDistrictReference.setUserId(suggestSettingRequestModel.getUserId());
                tbDistrictReference.setDistrictId(districtId);
                districtReferenceService.save(tbDistrictReference);
            }
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(CONFLICT).build();
        }
    }
}
