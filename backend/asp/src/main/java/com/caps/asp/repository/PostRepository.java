package com.caps.asp.repository;

import com.caps.asp.model.TbPost;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

public interface PostRepository extends JpaRepository<TbPost, Integer>, JpaSpecificationExecutor<TbPost> {
    List<TbPost> findByUserIdAndTypeId(int userId, int typeId);

    TbPost findByPostId(int postId);

    TbPost findByRoomId(int roomId);

    Page<TbPost> findAllByUserId(int userId, Pageable pageable);

    Page<TbPost> findAllByTypeId(int typeId, Pageable pageable);

    List<TbPost> findAllByTypeId(int typeId);

    Page<TbPost> findAllByRoomIdIn(List<Integer> roomIds, Pageable pageable);

    List<TbPost> findAllByRoomIdIn(List<Integer> roomIds);

    void removeByRoomId(int roomId);

    List<TbPost> findAllByUserId(int userId);

    Page<TbPost> findAllByUserIdAndTypeIdOrderByDatePostDesc(int userId, int typeId, Pageable pageable);

    List<TbPost> findAllByUserIdAndRoomIdOrderByDatePostDesc(int userId, int roomId);

    List<TbPost> findAllByRoomId(int roomId);

    void removeAllByUserId(int userId);

    List<TbPost> findAllByUserIdAndTypeIdOrderByDatePostDesc(int userId, int typeId);

    void removeByPostId(int postId);

}
