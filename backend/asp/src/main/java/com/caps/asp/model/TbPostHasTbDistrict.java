package com.caps.asp.model;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "tb_post_has_tb_district", schema = "asp", catalog = "")
public class TbPostHasTbDistrict {
    private Integer id;
    private Integer postId;
    private Integer districtId;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @Basic
    @Column(name = "post_id", nullable = false)
    public Integer getPostId() {
        return postId;
    }

    public void setPostId(Integer postId) {
        this.postId = postId;
    }

    @Basic
    @Column(name = "district_id", nullable = false)
    public Integer getDistrictId() {
        return districtId;
    }

    public void setDistrictId(Integer districtId) {
        this.districtId = districtId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TbPostHasTbDistrict that = (TbPostHasTbDistrict) o;
        return Objects.equals(id, that.id) &&
                Objects.equals(postId, that.postId) &&
                Objects.equals(districtId, that.districtId);
    }

    @Override
    public int hashCode() {

        return Objects.hash(id, postId, districtId);
    }
}
