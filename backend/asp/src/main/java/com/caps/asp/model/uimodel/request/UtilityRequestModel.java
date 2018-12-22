package com.caps.asp.model.uimodel.request;

public class UtilityRequestModel {
    private int utilityId;
    private String name;
    private String brand;
    private String description;
    private int quantity;

    public UtilityRequestModel() {
    }

    public UtilityRequestModel(int utilityId, String name, String brand, String description, int quantity) {
        this.utilityId = utilityId;
        this.name = name;
        this.brand = brand;
        this.description = description;
        this.quantity = quantity;
    }

    public int getUtilityId() {
        return utilityId;
    }

    public void setUtilityId(int utilityId) {
        this.utilityId = utilityId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
