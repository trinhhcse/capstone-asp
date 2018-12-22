package com.caps.asp.repository;

import com.caps.asp.model.TbImage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ImageRepository extends JpaRepository<TbImage, Integer> {
    void deleteAllByRoomId(int roomId);

    List<TbImage> findAllByRoomId(int roomId);
}
