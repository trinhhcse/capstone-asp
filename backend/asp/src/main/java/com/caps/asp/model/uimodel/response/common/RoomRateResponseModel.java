package com.caps.asp.model.uimodel.response.common;

import com.caps.asp.model.TbRoomRate;
import com.caps.asp.model.TbUser;
import com.caps.asp.model.TbUserRate;

import java.sql.Date;
import java.sql.Timestamp;

public class RoomRateResponseModel {
    private Double security;
    private Double location;
    private Double utility;
    private String username;
    private int userId;
    private String imageProfile;
    private String comment;
    private Timestamp date;

    public RoomRateResponseModel() {
    }

    public RoomRateResponseModel(TbRoomRate tbRoomrate, TbUser user) {
        this.security = tbRoomrate.getSecurityRate();
        this.location = tbRoomrate.getLocationRate();
        this.utility = tbRoomrate.getUtilityRate();
        this.username = user.getUsername();
        this.userId = user.getUserId();
        this.imageProfile = user.getImageProfile();
        this.comment = tbRoomrate.getComment();
        this.date = tbRoomrate.getDate();
    }
    public RoomRateResponseModel(Double security, Double location, Double utility, String username, int userId, String imageProfile, String comment, Timestamp date) {
        this.security = security;
        this.location = location;
        this.utility = utility;
        this.username = username;
        this.userId = userId;
        this.imageProfile = imageProfile;
        this.comment = comment;
        this.date = date;
    }

    public Double getSecurity() {
        return security;
    }

    public void setSecurity(Double security) {
        this.security = security;
    }

    public Double getLocation() {
        return location;
    }

    public void setLocation(Double location) {
        this.location = location;
    }

    public Double getUtility() {
        return utility;
    }

    public void setUtility(Double utility) {
        this.utility = utility;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getImageProfile() {
        return imageProfile;
    }

    public void setImageProfile(String imageProfile) {
        this.imageProfile = imageProfile;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }
}
