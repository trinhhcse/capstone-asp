package com.caps.asp.model.uimodel.response.common;

import com.caps.asp.model.TbRoomHasUtility;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class RoomResponseModel {
    private int roomId;
    private String name;
    private Double price;
    private Integer area;
    private String address;
    private Integer maxGuest;
    private Integer currentMember;
    private int userId;
    private int cityId;
    private int districtId;
    private Timestamp dateCreated;
    private int statusId;
    private List<TbRoomHasUtility> utilities;
    private List<String> imageUrls;
    private List<MemberResponseModel> members;
    private String description;
    private String  phoneNumber;
    private Double latitude;
    private Double longitude;
    private Double avarageSecurity;
    private Double avarageLocation;
    private Double avarageUtility;
    private List<RoomRateResponseModel> roomRateResponseModels;

    public RoomResponseModel() {
    }

    public RoomResponseModel(int roomId, String name, Double price, Integer area, String address, Integer maxGuest, Integer currentMember, int userId, int cityId, int districtId, Timestamp dateCreated, int statusId, List<TbRoomHasUtility> utilities, List<String> imageUrls, List<MemberResponseModel> members, String description, String phoneNumber, Double latitude, Double longitude, Double avarageSecurity, Double avarageLocation, Double avarageUtility, List<RoomRateResponseModel> roomRateResponseModels) {
        this.roomId = roomId;
        this.name = name;
        this.price = price;
        this.area = area;
        this.address = address;
        this.maxGuest = maxGuest;
        this.currentMember = currentMember;
        this.userId = userId;
        this.cityId = cityId;
        this.districtId = districtId;
        this.dateCreated = dateCreated;
        this.statusId = statusId;
        this.utilities = utilities;
        this.imageUrls = imageUrls;
        this.members = members;
        this.description = description;
        this.phoneNumber = phoneNumber;
        this.latitude = latitude;
        this.longitude = longitude;
        this.avarageSecurity = avarageSecurity;
        this.avarageLocation = avarageLocation;
        this.avarageUtility = avarageUtility;
        this.roomRateResponseModels = roomRateResponseModels;
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

    public Integer getCurrentMember() {
        return currentMember;
    }

    public void setCurrentMember(Integer currentMember) {
        this.currentMember = currentMember;
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

    public Timestamp getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Timestamp dateCreated) {
        this.dateCreated = dateCreated;
    }

    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(int statusId) {
        this.statusId = statusId;
    }

    public List<TbRoomHasUtility> getUtilities() {
        return utilities;
    }

    public void setUtilities(List<TbRoomHasUtility> utilities) {
        this.utilities = utilities;
    }

    public List<String> getImageUrls() {
        return imageUrls;
    }

    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }

    public List<MemberResponseModel> getMembers() {
        return members;
    }

    public void setMembers(List<MemberResponseModel> members) {
        this.members = members;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getAvarageSecurity() {
        return avarageSecurity;
    }

    public void setAvarageSecurity(Double avarageSecurity) {
        this.avarageSecurity = avarageSecurity;
    }

    public Double getAvarageLocation() {
        return avarageLocation;
    }

    public void setAvarageLocation(Double avarageLocation) {
        this.avarageLocation = avarageLocation;
    }

    public Double getAvarageUtility() {
        return avarageUtility;
    }

    public void setAvarageUtility(Double avarageUtility) {
        this.avarageUtility = avarageUtility;
    }

    public List<RoomRateResponseModel> getRoomRateResponseModels() {
        return roomRateResponseModels;
    }

    public void setRoomRateResponseModels(List<RoomRateResponseModel> roomRateResponseModels) {
        this.roomRateResponseModels = roomRateResponseModels;
    }
}
