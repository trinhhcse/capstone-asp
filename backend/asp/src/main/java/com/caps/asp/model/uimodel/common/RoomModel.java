package com.caps.asp.model.uimodel.common;

import com.caps.asp.model.uimodel.request.UtilityRequestModel;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class RoomModel {

    private int roomId;
    private String name;
    private Double price;
    private Integer area;
    private String address;
    private Integer maxGuest;
    @JsonFormat(pattern = "dd-MM-yyyy")
    private Timestamp dateCreated;
    private Integer currentNumber;
    private String description;
    private int status;
    private int userId;
    private int cityId;
    private int districtId;
    private Double longitude;
    private Double latitude;
    private List<UtilityRequestModel> utilities;
    private List<String> imageUrls;
    List<Integer> userIds;

    public RoomModel(int roomId, String name, Double price, Integer area, String address, Integer maxGuest, Timestamp dateCreated, Integer currentNumber, String description, int status, int userId, int cityId, int districtId, Double longitude, Double latitude, List<UtilityRequestModel> utilities, List<String> imageUrls, List<Integer> userIds) {
        this.roomId = roomId;
        this.name = name;
        this.price = price;
        this.area = area;
        this.address = address;
        this.maxGuest = maxGuest;
        this.dateCreated = dateCreated;
        this.currentNumber = currentNumber;
        this.description = description;
        this.status = status;
        this.userId = userId;
        this.cityId = cityId;
        this.districtId = districtId;
        this.longitude = longitude;
        this.latitude = latitude;
        this.utilities = utilities;
        this.imageUrls = imageUrls;
        this.userIds = userIds;
    }

    public RoomModel() {
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Integer getArea() {
        return area;
    }

    public void setArea(Integer area) {
        this.area = area;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Integer getMaxGuest() {
        return maxGuest;
    }

    public void setMaxGuest(Integer maxGuest) {
        this.maxGuest = maxGuest;
    }

    public Timestamp getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Timestamp dateCreated) {
        this.dateCreated = dateCreated;
    }

    public Integer getCurrentNumber() {
        return currentNumber;
    }

    public void setCurrentNumber(Integer currentNumber) {
        this.currentNumber = currentNumber;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCityId() {
        return cityId;
    }

    public void setCityId(int cityId) {
        this.cityId = cityId;
    }

    public int getDistrictId() {
        return districtId;
    }

    public void setDistrictId(int districtId) {
        this.districtId = districtId;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public List<UtilityRequestModel> getUtilities() {
        return utilities;
    }

    public void setUtilities(List<UtilityRequestModel> utilities) {
        this.utilities = utilities;
    }

    public List<String> getImageUrls() {
        return imageUrls;
    }

    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }

    public List<Integer> getUserIds() {
        return userIds;
    }

    public void setUserIds(List<Integer> userIds) {
        this.userIds = userIds;
    }
}
