package com.caps.asp.model;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Objects;

@Entity
@Table(name = "tb_post", schema = "asp", catalog = "")
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "getSuggestedList",
                procedureName = "CalculateDistance",
                resultClasses = {TbPost.class},
                parameters = {
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "userId", type = Integer.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "pageOf", type = Integer.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "size", type = Integer.class)
                }),
        @NamedStoredProcedureQuery(name = "getSuggestedListForMember",
                procedureName = "CalculateDistanceForMember",
                resultClasses = {TbPost.class},
                parameters = {
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "latitude", type = Float.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "longitude", type = Float.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "cityId", type = Integer.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "pageOf", type = Integer.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "size", type = Integer.class)
                })
})
public class TbPost {
    private Integer postId;
    private String name;
    private String phoneContact;
    private Integer numberPartner;
    private Integer genderPartner;
    private Timestamp datePost;
    private Integer typeId;
    private Integer userId;
    private Integer roomId;
    private Double longtitude;
    private Double lattitude;
    private Double minPrice;
    private Double maxPrice;
    private String description;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_id", nullable = false)
    public Integer getPostId() {
        return postId;
    }

    public void setPostId(Integer postId) {
        this.postId = postId;
    }

    @Basic
    @Column(name = "name", nullable = true, length = 50)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Basic
    @Column(name = "phone_contact", nullable = true, length = 15)
    public String getPhoneContact() {
        return phoneContact;
    }

    public void setPhoneContact(String phoneContact) {
        this.phoneContact = phoneContact;
    }

    @Basic
    @Column(name = "number_partner", nullable = true)
    public Integer getNumberPartner() {
        return numberPartner;
    }

    public void setNumberPartner(Integer numberPartner) {
        this.numberPartner = numberPartner;
    }

    @Basic
    @Column(name = "gender_partner", nullable = true)
    public Integer getGenderPartner() {
        return genderPartner;
    }

    public void setGenderPartner(Integer genderPartner) {
        this.genderPartner = genderPartner;
    }

    @Basic
    @Column(name = "date_post", nullable = true)
    public Timestamp getDatePost() {
        return datePost;
    }

    public void setDatePost(Timestamp datePost) {
        this.datePost = datePost;
    }

    @Basic
    @Column(name = "type_id", nullable = false)
    public Integer getTypeId() {
        return typeId;
    }

    public void setTypeId(Integer typeId) {
        this.typeId = typeId;
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
    @Column(name = "room_id", nullable = true)
    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    @Basic
    @Column(name = "longtitude", nullable = true, precision = 0)
    public Double getLongtitude() {
        return longtitude;
    }

    public void setLongtitude(Double longtitude) {
        this.longtitude = longtitude;
    }

    @Basic
    @Column(name = "lattitude", nullable = true, precision = 0)
    public Double getLattitude() {
        return lattitude;
    }

    public void setLattitude(Double lattitude) {
        this.lattitude = lattitude;
    }

    @Basic
    @Column(name = "min_price", nullable = true, precision = 0)
    public Double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(Double minPrice) {
        this.minPrice = minPrice;
    }

    @Basic
    @Column(name = "max_price", nullable = true, precision = 0)
    public Double getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(Double maxPrice) {
        this.maxPrice = maxPrice;
    }

    @Basic
    @Column(name = "description", nullable = true, length = 255)
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TbPost post = (TbPost) o;
        return Objects.equals(postId, post.postId) &&
                Objects.equals(name, post.name) &&
                Objects.equals(phoneContact, post.phoneContact) &&
                Objects.equals(numberPartner, post.numberPartner) &&
                Objects.equals(genderPartner, post.genderPartner) &&
                Objects.equals(datePost, post.datePost) &&
                Objects.equals(typeId, post.typeId) &&
                Objects.equals(userId, post.userId) &&
                Objects.equals(roomId, post.roomId) &&
                Objects.equals(longtitude, post.longtitude) &&
                Objects.equals(lattitude, post.lattitude) &&
                Objects.equals(minPrice, post.minPrice) &&
                Objects.equals(maxPrice, post.maxPrice) &&
                Objects.equals(description, post.description);
    }

    @Override
    public int hashCode() {

        return Objects.hash(postId, name, phoneContact, numberPartner, genderPartner, datePost, typeId, userId, roomId, longtitude, lattitude, minPrice, maxPrice, description);
    }
}
