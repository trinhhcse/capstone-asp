package com.caps.asp.model.uimodel.common;

import java.util.List;

public class UserSuggestSettingModel {
    private List<Integer> utilities;
    private List<Integer> districts;
    private List<Double> price;

    public UserSuggestSettingModel() {
    }

    public UserSuggestSettingModel(List<Integer> utilities, List<Integer> districts, List<Double> price) {
        this.utilities = utilities;
        this.districts = districts;
        this.price = price;
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
