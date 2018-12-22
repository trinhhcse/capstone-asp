package com.caps.asp.model.uimodel.request.common;

import com.caps.asp.model.uimodel.request.MemberRequestModel;

import java.sql.Date;
import java.util.List;

public class RoomMemberRequestModel {
     private int roomId;
     List<MemberRequestModel> memberRequestModels;

    public RoomMemberRequestModel() {
    }

    public RoomMemberRequestModel(int roomId, List<MemberRequestModel> memberRequestModels) {
        this.roomId = roomId;
        this.memberRequestModels = memberRequestModels;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public List<MemberRequestModel> getMemberRequestModels() {
        return memberRequestModels;
    }

    public void setMemberRequestModels(List<MemberRequestModel> memberRequestModels) {
        this.memberRequestModels = memberRequestModels;
    }
}
