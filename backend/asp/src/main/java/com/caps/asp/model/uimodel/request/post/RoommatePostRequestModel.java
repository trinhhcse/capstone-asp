package com.caps.asp.model.uimodel.request.post;

import java.util.List;

public class RoommatePostRequestModel extends BasePostRequestModel {

    private double maxPrice;
    private List<Integer> districtIds;
    private List<Integer> utilityIds;
    private int cityId;

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

    public List<Integer> getUtilityIds() {
        return utilityIds;
    }

    public void setUtilityIds(List<Integer> utilityIds) {
        this.utilityIds = utilityIds;
    }

    public int getCityId() {
        return cityId;
    }

    public void setCityId(int cityId) {
        this.cityId = cityId;
    }
}
