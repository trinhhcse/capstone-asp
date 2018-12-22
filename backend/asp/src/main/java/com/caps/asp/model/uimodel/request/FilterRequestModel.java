package com.caps.asp.model.uimodel.request;

import java.util.List;

public class FilterRequestModel {
    private List<Integer> utilities;
    private List<Integer> districts;
    private List<Double> price;
    private Integer gender;

    public FilterRequestModel() {
    }

    public FilterRequestModel(List<Integer> utilities, List<Integer> districts, List<Double> price, Integer gender) {
        this.utilities = utilities;
        this.districts = districts;
        this.price = price;
        this.gender = gender;
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

    public Integer getGender() {
        return gender;
    }

    public void setGender(Integer gender) {
        this.gender = gender;
    }
}
