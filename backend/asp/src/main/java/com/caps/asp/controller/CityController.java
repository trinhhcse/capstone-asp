package com.caps.asp.controller;

import com.caps.asp.model.TbCity;
import com.caps.asp.service.CityService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import static org.springframework.http.HttpStatus.NOT_FOUND;
import static org.springframework.http.HttpStatus.OK;

@RestController
public class CityController {

    public final CityService cityService;

    public CityController(CityService cityService) {
        this.cityService = cityService;
    }

    @GetMapping("/city")
    public ResponseEntity<List<TbCity>> getAllDistrict() {
        try {
            List<TbCity> cities = cityService.findAll();
            Collections.sort(cities, new Comparator<TbCity>() {
                @Override
                public int compare(TbCity c1, TbCity c2) {
                    return c1.getName().compareTo(c2.getName());
                }
            });
            return ResponseEntity.status(OK).body(cities);
        } catch (Exception e) {
            return ResponseEntity.status(NOT_FOUND).build();
        }
    }
}
