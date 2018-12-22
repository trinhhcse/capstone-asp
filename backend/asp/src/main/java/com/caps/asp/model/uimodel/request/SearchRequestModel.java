package com.caps.asp.model.uimodel.request;

public class SearchRequestModel {
    String address;
    double latitude;
    double longitude;
    int userId;

    public SearchRequestModel(String address, double latitude, double longitude, int userId) {
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.userId = userId;
    }

    public SearchRequestModel() {
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }
}
