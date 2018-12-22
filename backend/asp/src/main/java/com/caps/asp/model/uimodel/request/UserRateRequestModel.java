package com.caps.asp.model.uimodel.request;

import java.sql.Date;



public class UserRateRequestModel {
    private Double behaviourRate;
    private Double lifeStyleRate;
    private Double paymentRate;
    private Date date;
    private String comment;
    private Integer userId;
    private Integer ownerId;




    public UserRateRequestModel(Double behaviourRate, Double lifeStyleRate, Double paymentRate, Date date, String comment, Integer userId, Integer ownerId) {

        this.behaviourRate = behaviourRate;
        this.lifeStyleRate = lifeStyleRate;
        this.paymentRate = paymentRate;
        this.date = date;
        this.comment = comment;
        this.userId = userId;
        this.ownerId = ownerId;
    }


    public UserRateRequestModel() {
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

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

}
