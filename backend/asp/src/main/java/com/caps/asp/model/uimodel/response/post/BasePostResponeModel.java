package com.caps.asp.model.uimodel.response.post;

import com.caps.asp.model.uimodel.response.common.UserResponseModel;

import java.sql.Date;
import java.sql.Timestamp;

public class BasePostResponeModel {
    private Integer postId;
    private String phoneContact;
    private Timestamp date;
    private UserResponseModel userResponseModel;
    private boolean isFavourite;
    private double minPrice;
    private Integer favouriteId;

    public BasePostResponeModel(Integer postId, String phoneContact, Timestamp date, UserResponseModel userResponseModel, boolean isFavourite, double minPrice, Integer favouriteId) {
        this.postId = postId;
        this.phoneContact = phoneContact;
        this.date = date;
        this.userResponseModel = userResponseModel;
        this.isFavourite = isFavourite;
        this.minPrice = minPrice;
        this.favouriteId = favouriteId;
    }

    public BasePostResponeModel() {
    }

    public Integer getPostId() {
        return postId;
    }

    public void setPostId(Integer postId) {
        this.postId = postId;
    }

    public String getPhoneContact() {
        return phoneContact;
    }

    public void setPhoneContact(String phoneContact) {
        this.phoneContact = phoneContact;
    }

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    public UserResponseModel getUserResponseModel() {
        return userResponseModel;
    }

    public void setUserResponseModel(UserResponseModel userResponseModel) {
        this.userResponseModel = userResponseModel;
    }

    public boolean isFavourite() {
        return isFavourite;
    }

    public void setFavourite(boolean favourite) {
        isFavourite = favourite;
    }

    public double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(double minPrice) {
        this.minPrice = minPrice;
    }

    public Integer getFavouriteId() {
        return favouriteId;
    }

    public void setFavouriteId(Integer favouriteId) {
        this.favouriteId = favouriteId;
    }
}
