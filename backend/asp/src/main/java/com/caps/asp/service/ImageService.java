package com.caps.asp.service;

import com.caps.asp.model.TbImage;
import com.caps.asp.repository.ImageRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ImageService {

    public final ImageRepository imageRepository;

    public ImageService(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }

    public void saveImage(TbImage image){
        imageRepository.saveAndFlush(image);
    }

    public void deleteAllImageByRoomId(int roomId){
        imageRepository.deleteAllByRoomId(roomId);
    }

    public List<TbImage> findAllByRoomId(int roomId){
        return imageRepository.findAllByRoomId(roomId);
    }
}
