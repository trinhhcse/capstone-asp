package com.caps.asp.model;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "tb_image", schema = "asp", catalog = "")
public class TbImage {
    private Integer imageId;
    private String linkUrl;
    private Integer roomId;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "image_id", nullable = false)
    public Integer getImageId() {
        return imageId;
    }

    public void setImageId(Integer imageId) {
        this.imageId = imageId;
    }

    @Basic
    @Column(name = "link_url", nullable = true, length = 255)
    public String getLinkUrl() {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl) {
        this.linkUrl = linkUrl;
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
        TbImage image = (TbImage) o;
        return Objects.equals(imageId, image.imageId) &&
                Objects.equals(linkUrl, image.linkUrl) &&
                Objects.equals(roomId, image.roomId);
    }

    @Override
    public int hashCode() {

        return Objects.hash(imageId, linkUrl, roomId);
    }
}
