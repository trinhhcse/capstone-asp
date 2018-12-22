package com.caps.asp.service;

import com.caps.asp.model.TbPostHasUtility;
import com.caps.asp.repository.PostHasUtilityRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PostHasUtilityService {

    public final PostHasUtilityRepository postHasUtilityRepository;

    public PostHasUtilityService(PostHasUtilityRepository postHasUtilityRepository) {
        this.postHasUtilityRepository = postHasUtilityRepository;
    }

    public void save(TbPostHasUtility tbPostHasUtility){
            postHasUtilityRepository.save(tbPostHasUtility);
    }

    public void deleteAllPostHasUtilityByPostId(int postId){
        postHasUtilityRepository.deleteAllByPostId(postId);
    }

    public List<TbPostHasUtility> findAllByPostId(int postId) {
        return postHasUtilityRepository.findAllByPostId(postId);
    }
    public void removeAllByPostId(int postId){
        postHasUtilityRepository.removeAllByPostId(postId);
    }
}
