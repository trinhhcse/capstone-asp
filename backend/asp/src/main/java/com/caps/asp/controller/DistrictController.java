package com.caps.asp.controller;

import com.caps.asp.model.TbDistrict;
import com.caps.asp.service.DistrictService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import static org.springframework.http.HttpStatus.NOT_FOUND;
import static org.springframework.http.HttpStatus.OK;

@RestController
public class DistrictController {

    public final DistrictService districtService;

    public DistrictController(DistrictService districtService) {
        this.districtService = districtService;
    }

    @GetMapping("/district/{cityId}")
    public ResponseEntity<List<TbDistrict>> getAllDistrictByCity(@PathVariable int cityId) {
        try {
            List<TbDistrict> districts = districtService.findAllByCity(cityId);
            Collections.sort(districts, new Comparator<TbDistrict>() {
                        @Override
                        public int compare(TbDistrict d1, TbDistrict d2) {
                            return d1.getName().compareTo(d2.getName());
                        }
                    }
            );
            return ResponseEntity.status(OK).body(districts);
        } catch (Exception e) {
            return ResponseEntity.status(NOT_FOUND).build();
        }
    }

    @GetMapping("/district")
    public ResponseEntity<List<TbDistrict>> getAll() {
        try {
            return ResponseEntity.status(OK).body(districtService.findAll());
        } catch (Exception e) {
            return ResponseEntity.status(NOT_FOUND).build();
        }
    }
}
