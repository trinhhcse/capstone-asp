package com.caps.asp.model;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "tb_role", schema = "asp", catalog = "")
public class TbRole {
    private Integer roleId;
    private String rolename;

    @Id
    @Column(name = "role_id", nullable = false)
    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    @Basic
    @Column(name = "rolename", nullable = true, length = 45)
    public String getRolename() {
        return rolename;
    }

    public void setRolename(String rolename) {
        this.rolename = rolename;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TbRole tbRole = (TbRole) o;
        return Objects.equals(roleId, tbRole.roleId) &&
                Objects.equals(rolename, tbRole.rolename);
    }

    @Override
    public int hashCode() {

        return Objects.hash(roleId, rolename);
    }
}
