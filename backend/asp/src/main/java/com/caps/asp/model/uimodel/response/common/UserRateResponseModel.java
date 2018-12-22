package com.caps.asp.model.uimodel.response.common;

import com.caps.asp.model.TbUser;
import com.caps.asp.model.TbUserRate;

import java.sql.Timestamp;

public class UserRateResponseModel {

    private Double behaviourRate;
    private Double lifeStyleRate;
    private Double paymentRate;
    private String username;
    private int userId;
    private String imageProfile;
    private String comment;
    private Timestamp date;

    public UserRateResponseModel() {
    }
    public UserRateResponseModel(TbUserRate userRate, TbUser user) {
        this.behaviourRate = userRate.getBehaviourRate();
        this.lifeStyleRate = userRate.getLifeStyleRate();
        this.paymentRate = userRate.getPaymentRate();
        this.username = user.getUsername();
        this.userId = userRate.getOwnerId();
        this.imageProfile = user.getImageProfile();
        this.comment = userRate.getComment();
        this.date = userRate.getDate();
    }

    public UserRateResponseModel(Double behaviourRate, Double lifeStyleRate, Double paymentRate, String username, int userId, String imageProfile, String comment, Timestamp date) {
        this.behaviourRate = behaviourRate;
        this.lifeStyleRate = lifeStyleRate;
        this.paymentRate = paymentRate;
        this.username = username;
        this.userId = userId;
        this.imageProfile = imageProfile;
        this.comment = comment;
        this.date = date;
    }

    public Double getBehaviourRate() {
        return behaviourRate;
    }

    public void setBehaviourRate(Double behaviourRate) {
        this.behaviourRate = behaviourRate;
    }

    public Double getLifeStyleRate() {
        return lifeStyleRate;
    }

    public void setLifeStyleRate(Double lifeStyleRate) {
        this.lifeStyleRate = lifeStyleRate;
    }

    public Double getPaymentRate() {
        return paymentRate;
    }

    public void setPaymentRate(Double paymentRate) {
        this.paymentRate = paymentRate;
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
