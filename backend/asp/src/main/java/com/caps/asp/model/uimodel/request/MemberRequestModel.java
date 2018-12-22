package com.caps.asp.model.uimodel.request;

import java.sql.Date;
import java.util.Objects;

public class MemberRequestModel {
    private int userId;
    private int roleId;

    public MemberRequestModel() {
    }

    public MemberRequestModel(int userId, int roleId) {
        this.userId = userId;
        this.roleId = roleId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MemberRequestModel that = (MemberRequestModel) o;
        return userId == that.userId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId);
    }
}
