package com.caps.asp.model.uimodel.response.common;

public class UploadImageResponseModel {
    private String name;
    private String imageUrl;

    public UploadImageResponseModel() {
    }

    public UploadImageResponseModel(String name, String imageUrl) {
        this.name = name;
        this.imageUrl = imageUrl;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
