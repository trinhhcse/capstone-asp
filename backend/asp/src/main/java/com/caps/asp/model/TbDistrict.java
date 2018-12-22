package com.caps.asp.model;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "tb_district", schema = "asp", catalog = "")
public class TbDistrict {
    private Integer districtId;
    private String name;
    private Integer cityId;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "district_id", nullable = false)
    public Integer getDistrictId() {
        return districtId;
    }

    public void setDistrictId(Integer districtId) {
        this.districtId = districtId;
    }

    @Basic
    @Column(name = "name", nullable = true, length = 45)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Basic
    @Column(name = "city_id", nullable = false)
    public Integer getCityId() {
        return cityId;
    }

    public void setCityId(Integer cityId) {
        this.cityId = cityId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TbDistrict district = (TbDistrict) o;
        return Objects.equals(districtId, district.districtId) &&
                Objects.equals(name, district.name) &&
                Objects.equals(cityId, district.cityId);
    }

    @Override
    public int hashCode() {

        return Objects.hash(districtId, name, cityId);
    }
}
