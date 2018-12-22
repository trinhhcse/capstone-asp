package com.caps.asp.repository;

import com.caps.asp.model.TbFavourite;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FavouriteRepository extends JpaRepository<TbFavourite, Integer> {

    Page<TbFavourite> findAllByUserId(int userId, Pageable pageable);

    TbFavourite findByUserIdAndPostId(int userId, int postId);

    boolean removeByUserIdAndAndPostId(int userId, int postId);

    void removeAllByPostId(int postId);
}
