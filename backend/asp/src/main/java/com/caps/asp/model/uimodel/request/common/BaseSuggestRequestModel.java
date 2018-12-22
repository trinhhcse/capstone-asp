package com.caps.asp.model.uimodel.request.common;

public class BaseSuggestRequestModel {

    private int userId;
    private Double longitude;
    private Double latitude;
    private int typeId;
    private Integer page;
    private Integer offset;
    private Integer cityId;


//common (BASE)
    //TH1: role gi
        //Master
            //check co bai dang chua
                //Co roi-> bai dang cua roomaster khac  gan nhat
                //chua
                    //common giong member

        //Member
            //check co setting chua
                //co roi ->common cai nao phu hop nhat
                //chua cos -> check long lat
                    //co long lat -> gan nhat
                    //chua co long lat -> moi nhat

    public BaseSuggestRequestModel() {
    }

    public BaseSuggestRequestModel(int userId, Double longitude, Double latitude, int typeId, Integer offset, Integer cityId) {
        this.userId = userId;
        this.longitude = longitude;
        this.latitude = latitude;
        this.typeId = typeId;
        this.offset = offset;
        this.cityId = cityId;
    }

    public Integer getCityId() {
        return cityId;
    }

    public void setCityId(Integer cityId) {
        this.cityId = cityId;
    }

    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public Integer getOffset() {
        return offset;
    }

    public void setOffset(Integer offset) {
        this.offset = offset;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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
}
