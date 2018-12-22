package com.caps.asp.repository;

import com.caps.asp.model.TbPostHasUtility;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PostHasUtilityRepository extends JpaRepository<TbPostHasUtility, Integer> {
    void deleteAllByPostId(int postId);
    List<TbPostHasUtility> findAllByPostId(int postId);
    void removeAllByPostId(int postId);
}
