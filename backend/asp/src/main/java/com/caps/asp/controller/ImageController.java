package com.caps.asp.controller;

import com.caps.asp.model.uimodel.response.common.UploadImageResponseModel;
import com.caps.asp.service.AmazonService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class ImageController {
    private final AmazonService amazonService;

    public ImageController(AmazonService amazonService) {
        this.amazonService = amazonService;
    }

    @PostMapping("/image/upload")
    public ResponseEntity uploadRoomImage(@RequestParam(value = "image") MultipartFile image) {
        try {
            return ResponseEntity.status(HttpStatus.CREATED).body(new UploadImageResponseModel(image.getOriginalFilename(), amazonService.uploadFile(image)));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
