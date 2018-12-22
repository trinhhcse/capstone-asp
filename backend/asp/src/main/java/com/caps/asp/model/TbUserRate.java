package com.caps.asp.model;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Objects;

@Entity
@Table(name = "tb_user_rate", schema = "asp", catalog = "")
public class TbUserRate {
    private Integer id;
    private Double behaviourRate;
    private Double lifeStyleRate;
    private Double paymentRate;
    private Timestamp date;
    private String comment;
    private Integer userId;
    private Integer ownerId;

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
    @Column(name = "behaviour_rate", nullable = true, precision = 0)
    public Double getBehaviourRate() {
        return behaviourRate;
    }

    public void setBehaviourRate(Double behaviourRate) {
        this.behaviourRate = behaviourRate;
    }

    @Basic
    @Column(name = "life_style_rate", nullable = true, precision = 0)
    public Double getLifeStyleRate() {
        return lifeStyleRate;
    }

    public void setLifeStyleRate(Double lifeStyleRate) {
        this.lifeStyleRate = lifeStyleRate;
    }

    @Basic
    @Column(name = "payment_rate", nullable = true, precision = 0)
    public Double getPaymentRate() {
        return paymentRate;
    }

    public void setPaymentRate(Double paymentRate) {
        this.paymentRate = paymentRate;
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
    @Column(name = "comment", nullable = true, length = 255)
    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
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
    @Column(name = "owner_id", nullable = false)
    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TbUserRate that = (TbUserRate) o;
        return Objects.equals(id, that.id) &&
                Objects.equals(behaviourRate, that.behaviourRate) &&
                Objects.equals(lifeStyleRate, that.lifeStyleRate) &&
                Objects.equals(paymentRate, that.paymentRate) &&
                Objects.equals(date, that.date) &&
                Objects.equals(comment, that.comment) &&
                Objects.equals(userId, that.userId) &&
                Objects.equals(ownerId, that.ownerId);
    }

    @Override
    public int hashCode() {

        return Objects.hash(id, behaviourRate, lifeStyleRate, paymentRate, date, comment, userId, ownerId);
    }
}
