package com.caps.asp.model.uimodel.request.post;

public class BasePostRequestModel {
    private Integer userId;
    //minPrice is price of roompost and min price in roommate post
    private double minPrice;
    private String phoneContact;
    private int postId;

    public BasePostRequestModel(Integer userId, double minPrice, String phoneContact, int postId) {
        this.userId = userId;
        this.minPrice = minPrice;
        this.phoneContact = phoneContact;
        this.postId = postId;
    }

    public BasePostRequestModel() {
    }

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public String getPhoneContact() {
        return phoneContact;
    }

    public void setPhoneContact(String phoneContact) {
        this.phoneContact = phoneContact;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(double minPrice) {
        this.minPrice = minPrice;
    }
}
