package com.caps.asp.model.uimodel.response.post;

import com.caps.asp.model.TbRoomHasUtility;
import com.caps.asp.model.uimodel.response.common.UserResponseModel;
import com.caps.asp.model.uimodel.response.common.RoomRateResponseModel;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

//show room post detail
public class RoomPostResponseModel extends BasePostResponeModel {
    private String name;
    private Integer area;
    private String address;
    private List<TbRoomHasUtility> utilities;
    private List<String> imageUrls;
    private Integer numberPartner;
    private Integer genderPartner;
    private String description;
    private Double avarageSecurity;
    private Double avarageLocation;
    private Double avarageUtility;
    private List<RoomRateResponseModel> roomRateResponseModels;

    public RoomPostResponseModel(Integer postId, String phoneContact, Timestamp date, UserResponseModel userResponseModel, boolean isFavourite, double minPrice, Integer favouriteId, String name, Integer area, String address, List<TbRoomHasUtility> utilities, List<String> imageUrls, Integer numberPartner, Integer genderPartner, String description, Double avarageSecurity, Double avarageLocation, Double avarageUtility, List<RoomRateResponseModel> roomRateResponseModels) {
        super(postId, phoneContact, date, userResponseModel, isFavourite, minPrice, favouriteId);
        this.name = name;
        this.area = area;
        this.address = address;
        this.utilities = utilities;
        this.imageUrls = imageUrls;
        this.numberPartner = numberPartner;
        this.genderPartner = genderPartner;
        this.description = description;
        this.avarageSecurity = avarageSecurity;
        this.avarageLocation = avarageLocation;
        this.avarageUtility = avarageUtility;
        this.roomRateResponseModels = roomRateResponseModels;
    }

    public RoomPostResponseModel() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public Integer getNumberPartner() {
        return numberPartner;
    }

    public void setNumberPartner(Integer numberPartner) {
        this.numberPartner = numberPartner;
    }

    public Integer getGenderPartner() {
        return genderPartner;
    }

    public void setGenderPartner(Integer genderPartner) {
        this.genderPartner = genderPartner;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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
