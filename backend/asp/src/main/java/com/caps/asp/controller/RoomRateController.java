package com.caps.asp.controller;

import com.caps.asp.model.TbRoomHasUser;
import com.caps.asp.model.TbRoomRate;
import com.caps.asp.model.uimodel.request.RoomRateRequestModel;
import com.caps.asp.service.RoomHasUserService;
import com.caps.asp.service.RoomRateService;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.sql.Date;
import java.sql.Timestamp;

import static org.springframework.http.HttpStatus.CONFLICT;
import static org.springframework.http.HttpStatus.CREATED;


@RestController
public class RoomRateController {
    private final RoomRateService roomRateService;
    private final RoomHasUserService roomHasUserService;

    public RoomRateController(RoomRateService roomRateService, RoomHasUserService roomHasUserService) {
        this.roomRateService = roomRateService;
        this.roomHasUserService = roomHasUserService;
    }


    @PostMapping("/room/rate/save")
    public ResponseEntity saveRoomRate(@RequestBody RoomRateRequestModel roomRateRequestModel) {
        TbRoomRate roomRate = roomRateService.findAllByRoomIdAndUserId(roomRateRequestModel.getRoomId(), roomRateRequestModel.getUserId());
        TbRoomHasUser roomHasUser = roomHasUserService.findByUserIdAndRoomIdAndDateOutIsNull(roomRateRequestModel.getUserId(), roomRateRequestModel.getRoomId());
        if (roomHasUser != null ){
            if (roomRate == null) {
                roomRate = new TbRoomRate();
                roomRate.setId(0);
            }
            roomRate.setComment(roomRateRequestModel.getComment());
            Timestamp timestamp = new Timestamp(System.currentTimeMillis());
            roomRate.setDate(timestamp);
            roomRate.setLocationRate(roomRateRequestModel.getLocationRate());
            roomRate.setSecurityRate(roomRateRequestModel.getSecurityRate());
            roomRate.setUtilityRate(roomRateRequestModel.getUtilityRate());
            roomRate.setRoomId(roomRateRequestModel.getRoomId());
            roomRate.setUserId(roomRateRequestModel.getUserId());

            roomRateService.saveRoomRate(roomRate);
            return ResponseEntity.ok().build();
        }
       return ResponseEntity.status(CONFLICT).build();
    }
}

