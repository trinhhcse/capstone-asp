package com.caps.asp.model.uimodel.request;

import java.sql.Date;

public class RoomRateRequestModel {
    private Double securityRate;
    private Double locationRate;
    private Double utilityRate;
    private String comment;
    private Date date;
    private Integer userId;
    private Integer roomId;


    public RoomRateRequestModel(Double securityRate, Double locationRate, Double utilityRate, String comment, Date date, Integer userId, Integer roomId) {
        this.securityRate = securityRate;
        this.locationRate = locationRate;
        this.utilityRate = utilityRate;
        this.comment = comment;
        this.date = date;
        this.userId = userId;
        this.roomId = roomId;
    }

    public RoomRateRequestModel(){

    }

    public Double getSecurityRate() {
        return securityRate;
    }

    public void setSecurityRate(Double securityRate) {
        this.securityRate = securityRate;
    }

    public Double getLocationRate() {
        return locationRate;
    }

    public void setLocationRate(Double locationRate) {
        this.locationRate = locationRate;
    }

    public Double getUtilityRate() {
        return utilityRate;
    }

    public void setUtilityRate(Double utilityRate) {
        this.utilityRate = utilityRate;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }



}
