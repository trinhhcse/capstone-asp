package com.caps.asp.model;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Objects;

@Entity
@Table(name = "tb_room_rate", schema = "asp", catalog = "")
public class TbRoomRate {
    private Integer id;
    private Double securityRate;
    private Double locationRate;
    private Double utilityRate;
    private String comment;
    private Timestamp date;
    private Integer userId;
    private Integer roomId;

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
    @Column(name = "security_rate", nullable = true, precision = 0)
    public Double getSecurityRate() {
        return securityRate;
    }

    public void setSecurityRate(Double securityRate) {
        this.securityRate = securityRate;
    }

    @Basic
    @Column(name = "location_rate", nullable = true, precision = 0)
    public Double getLocationRate() {
        return locationRate;
    }

    public void setLocationRate(Double locationRate) {
        this.locationRate = locationRate;
    }

    @Basic
    @Column(name = "utility_rate", nullable = true, precision = 0)
    public Double getUtilityRate() {
        return utilityRate;
    }

    public void setUtilityRate(Double utilityRate) {
        this.utilityRate = utilityRate;
    }

    @Basic
    @Column(name = "comment", nullable = true, length = 255)
    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    @Basic
    @Column(name = "date", nullable = true)
    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    @Basic
    @Column(name = "user_id", nullable = false)
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    @Basic
    @Column(name = "room_id", nullable = false)
    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TbRoomRate that = (TbRoomRate) o;
        return Objects.equals(id, that.id) &&
                Objects.equals(securityRate, that.securityRate) &&
                Objects.equals(locationRate, that.locationRate) &&
                Objects.equals(utilityRate, that.utilityRate) &&
                Objects.equals(comment, that.comment) &&
                Objects.equals(date, that.date) &&
                Objects.equals(userId, that.userId) &&
                Objects.equals(roomId, that.roomId);
    }

    @Override
    public int hashCode() {

        return Objects.hash(id, securityRate, locationRate, utilityRate, comment, date, userId, roomId);
    }
}
