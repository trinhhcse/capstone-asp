package com.caps.asp.model.uimodel.request;

public class UserLoginModel {

    private String username;
    private String password;

    public UserLoginModel(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public UserLoginModel() {
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
