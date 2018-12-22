package com.caps.asp.model.firebase;

public class NotificationModel {

    private String user_id;
    private String noti_uuid;
    private String date;
    private String role_id;
    private String room_id;
    private String room_name;
    private String status;
    private String type;

    public NotificationModel(String user_id, String noti_uuid, String date, String role_id, String room_id, String room_name, String status, String type) {
        this.user_id = user_id;
        this.noti_uuid = noti_uuid;
        this.date = date;
        this.role_id = role_id;
        this.room_id = room_id;
        this.room_name = room_name;
        this.status = status;
        this.type = type;
    }

    public NotificationModel() {
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getNoti_uuid() {
        return noti_uuid;
    }

    public void setNoti_uuid(String noti_uuid) {
        this.noti_uuid = noti_uuid;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getRole_id() {
        return role_id;
    }

    public void setRole_id(String role_id) {
        this.role_id = role_id;
    }

    public String getRoom_id() {
        return room_id;
    }

    public void setRoom_id(String room_id) {
        this.room_id = room_id;
    }

    public String getRoom_name() {
        return room_name;
    }

    public void setRoom_name(String room_name) {
        this.room_name = room_name;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
