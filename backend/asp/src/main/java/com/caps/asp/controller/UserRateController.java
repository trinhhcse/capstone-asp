package com.caps.asp.controller;

import com.caps.asp.model.TbRoom;
import com.caps.asp.model.TbRoomHasUser;
import com.caps.asp.model.TbUserRate;
import com.caps.asp.model.uimodel.request.UserRateRequestModel;
import com.caps.asp.service.RoomHasUserService;
import com.caps.asp.service.RoomService;
import com.caps.asp.service.UserRateService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.sql.Date;
import java.sql.Timestamp;

import static org.springframework.http.HttpStatus.CONFLICT;
import static org.springframework.http.HttpStatus.CREATED;

@RestController
public class UserRateController {
    private UserRateService userRateService;
    private RoomHasUserService roomHasUserService;
    private RoomService roomService;

    public UserRateController(UserRateService userRateService, RoomHasUserService roomHasUserService, RoomService roomService) {
        this.userRateService = userRateService;
        this.roomHasUserService = roomHasUserService;
        this.roomService = roomService;
    }


    @PostMapping("/user/rate/save")
    public ResponseEntity saveUserRate(@RequestBody UserRateRequestModel userRateRequestModel) {
        TbUserRate userRate = userRateService.findByUserIdAndOwnerId(userRateRequestModel.getUserId(), userRateRequestModel.getOwnerId());
            TbRoomHasUser roomHasUser = roomHasUserService.getCurrentRoom(userRateRequestModel.getUserId());
            if (roomHasUser != null) {
                int roomId = roomHasUser.getRoomId();
                TbRoom room = roomService.findRoomById(roomId);
                int ownerId = room.getUserId();
                if (userRateRequestModel.getOwnerId() == ownerId) {
                    if (userRate == null) {
                        userRate = new TbUserRate();
                        userRate.setId(0);

                    }
                    Timestamp timestamp = new Timestamp(System.currentTimeMillis());
                    userRate.setDate(timestamp);
                    userRate.setBehaviourRate(userRateRequestModel.getBehaviourRate());
                    userRate.setLifeStyleRate(userRateRequestModel.getLifeStyleRate());
                    userRate.setPaymentRate(userRateRequestModel.getPaymentRate());
                    userRate.setComment(userRateRequestModel.getComment());
                    userRate.setUserId(userRateRequestModel.getUserId());
                    userRate.setOwnerId(userRateRequestModel.getOwnerId());

                    userRateService.saveUserRate(userRate);
                    return ResponseEntity.ok().build();
                }
                return ResponseEntity.status(CONFLICT).build();
            }

        return ResponseEntity.status(CONFLICT).build();
    }


}
