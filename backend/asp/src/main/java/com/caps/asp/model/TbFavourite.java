package com.caps.asp.model;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "tb_favourite", schema = "asp", catalog = "")
public class TbFavourite {
    private Integer id;
    private Integer userId;
    private Integer postId;

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
    @Column(name = "user_id", nullable = false)
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    @Basic
    @Column(name = "post_id", nullable = false)
    public Integer getPostId() {
        return postId;
    }

    public void setPostId(Integer postId) {
        this.postId = postId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TbFavourite favourite = (TbFavourite) o;
        return Objects.equals(id, favourite.id) &&
                Objects.equals(userId, favourite.userId) &&
                Objects.equals(postId, favourite.postId);
    }

    @Override
    public int hashCode() {

        return Objects.hash(id, userId, postId);
    }
}
