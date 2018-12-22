package com.caps.asp.model.uimodel.response.post;

import java.util.List;

public class RoommatePostResponseModel extends BasePostResponeModel {

    private List<Integer> utilityIds;
    private double maxPrice;
    private List<Integer> districtIds;
    private int cityId;

    public RoommatePostResponseModel() {
    }

    public RoommatePostResponseModel(List<Integer> utilityIds, double maxPrice, List<Integer> districtIds, int cityId) {
        this.utilityIds = utilityIds;
        this.maxPrice = maxPrice;
        this.districtIds = districtIds;
        this.cityId = cityId;
    }

    public int getCityId() {
        return cityId;
    }

    public void setCityId(int cityId) {
        this.cityId = cityId;
    }

    public List<Integer> getUtilityIds() {
        return utilityIds;
    }

    public void setUtilityIds(List<Integer> utilityIds) {
        this.utilityIds = utilityIds;
    }

    public double getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(double maxPrice) {
        this.maxPrice = maxPrice;
    }

    public List<Integer> getDistrictIds() {
        return districtIds;
    }

    public void setDistrictIds(List<Integer> districtIds) {
        this.districtIds = districtIds;
    }
}
