package com.caps.asp.model.uimodel.request.common;

import java.util.List;

public class SuggestSettingRequestModel {
    private List<Integer> utilities;
    private List<Integer> districts;
    private List<Double> price;
    private Integer userId;
    public SuggestSettingRequestModel() {
    }

    public SuggestSettingRequestModel(List<Integer> utilities, List<Integer> districts, List<Double> price, Integer userId) {
        this.utilities = utilities;
        this.districts = districts;
        this.price = price;
        this.userId = userId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public List<Integer> getUtilities() {
        return utilities;
    }

    public void setUtilities(List<Integer> utilities) {
        this.utilities = utilities;
    }

    public List<Integer> getDistricts() {
        return districts;
    }

    public void setDistricts(List<Integer> districts) {
        this.districts = districts;
    }

    public List<Double> getPrice() {
        return price;
    }

    public void setPrice(List<Double> price) {
        this.price = price;
    }
}
