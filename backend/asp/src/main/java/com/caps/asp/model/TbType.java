package com.caps.asp.model;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "tb_type", schema = "asp", catalog = "")
public class TbType {
    private Integer typeId;
    private String name;

    @Id
    @Column(name = "type_id", nullable = false)
    public Integer getTypeId() {
        return typeId;
    }

    public void setTypeId(Integer typeId) {
        this.typeId = typeId;
    }

    @Basic
    @Column(name = "name", nullable = true, length = 45)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TbType tbType = (TbType) o;
        return Objects.equals(typeId, tbType.typeId) &&
                Objects.equals(name, tbType.name);
    }

    @Override
    public int hashCode() {

        return Objects.hash(typeId, name);
    }
}
