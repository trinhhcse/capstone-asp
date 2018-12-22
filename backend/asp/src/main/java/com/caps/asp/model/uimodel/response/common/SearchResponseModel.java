package com.caps.asp.model.uimodel.response.common;

import com.caps.asp.model.uimodel.response.post.RoomPostResponseModel;

import java.util.List;

public class SearchResponseModel {
    List<RoomPostResponseModel> roomPostResponseModel;
    List<RoomPostResponseModel> nearByRoomPostResponseModels;

    public SearchResponseModel() {
    }

    public SearchResponseModel(List<RoomPostResponseModel> roomPostResponseModel, List<RoomPostResponseModel> nearByRoomPostResponseModels) {
        this.roomPostResponseModel = roomPostResponseModel;
        this.nearByRoomPostResponseModels = nearByRoomPostResponseModels;
    }

    public List<RoomPostResponseModel> getRoomPostResponseModel() {
        return roomPostResponseModel;
    }

    public void setRoomPostResponseModel(List<RoomPostResponseModel> roomPostResponseModel) {
        this.roomPostResponseModel = roomPostResponseModel;
    }

    public List<RoomPostResponseModel> getNearByRoomPostResponseModels() {
        return nearByRoomPostResponseModels;
    }

    public void setNearByRoomPostResponseModels(List<RoomPostResponseModel> nearByRoomPostResponseModels) {
        this.nearByRoomPostResponseModels = nearByRoomPostResponseModels;
    }
}
