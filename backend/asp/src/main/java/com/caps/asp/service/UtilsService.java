package com.caps.asp.service;

import com.caps.asp.model.*;
import com.caps.asp.model.uimodel.common.UserSuggestSettingModel;
import com.caps.asp.model.uimodel.request.FilterArgumentModel;
import com.caps.asp.model.uimodel.request.common.BaseSuggestRequestModel;
import com.caps.asp.model.uimodel.response.common.*;
import com.caps.asp.model.uimodel.response.post.RoomPostResponseModel;
import com.caps.asp.model.uimodel.response.post.RoommatePostResponseModel;
import com.caps.asp.service.filter.Filter;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static com.caps.asp.constant.Constant.NEWPOST;

@Service
public class UtilsService {

    private PostService postService;
    private RoomService roomService;
    private RoomHasUtilityService roomHasUtilityService;
    private UserService userService;
    private FavouriteService favouriteService;
    private ImageService imageService;
    private UtilityReferenceService utilityReferenceService;
    private DistrictReferenceService districtReferenceService;
    private DistrictService districtService;
    private RoomRateService roomRateService;
    private UserRateService userRateService;
    private PostHasUtilityService postHasUtilityService;
    private PostHasDistrictService postHasDistrictService;
    private RoomHasUserService roomHasUserService;
    private ReferenceService referenceService;


    public UtilsService(PostService postService, RoomService roomService, RoomHasUtilityService roomHasUtilityService, UserService userService, FavouriteService favouriteService, ImageService imageService, UtilityReferenceService utilityReferenceService, DistrictReferenceService districtReferenceService, DistrictService districtService, RoomRateService roomRateService, UserRateService userRateService, PostHasUtilityService postHasUtilityService, PostHasDistrictService postHasDistrictService, RoomHasUserService roomHasUserService, ReferenceService referenceService) {
        this.postService = postService;
        this.roomService = roomService;
        this.roomHasUtilityService = roomHasUtilityService;
        this.userService = userService;
        this.favouriteService = favouriteService;
        this.imageService = imageService;
        this.utilityReferenceService = utilityReferenceService;
        this.districtReferenceService = districtReferenceService;
        this.districtService = districtService;
        this.roomRateService = roomRateService;
        this.userRateService = userRateService;
        this.postHasUtilityService = postHasUtilityService;
        this.postHasDistrictService = postHasDistrictService;
        this.roomHasUserService = roomHasUserService;
        this.referenceService = referenceService;
    }
    public UserResponseModel getUserResponseModel(int userId){
        return getUserResponseModel(userId,true);
    }

    public UserResponseModel getUserResponseModel(int userId,boolean isGetUserReference){
        UserResponseModel userResponseModel = new UserResponseModel();
        TbUser userDb = userService.findById(userId);
        userResponseModel.setDob(userDb.getDob());
        userResponseModel.setUsername(userDb.getUsername());
        userResponseModel.setPhone(userDb.getPhone());
        userResponseModel.setGender(userDb.getGender());
        userResponseModel.setUserId(userDb.getUserId());
        userResponseModel.setFullname(userDb.getFullname());
        userResponseModel.setEmail(userDb.getEmail());
        userResponseModel.setImageProfile(userDb.getImageProfile());
        List<TbUserRate> userRates = userRateService.findAllByUserIdOrderByDateDesc(userId);
        if(isGetUserReference){
            UserSuggestSettingModel userSuggestSettingModel = new UserSuggestSettingModel();
            TbReference  reference = referenceService.getByUserId(userId);
            if(reference != null) {
                userSuggestSettingModel.setPrice(Arrays.asList(reference.getMinPrice(), reference.getMaxPrice()));

                List<TbUtilitiesReference> utilitiesReference = utilityReferenceService.findAllByUserId(userId);
                userSuggestSettingModel.setUtilities(utilitiesReference.stream().map(
                        tbUtilitiesReference -> tbUtilitiesReference.getUtilityId())
                        .collect(Collectors.toList()));

                List<TbDistrictReference> districtReferences = districtReferenceService.findAllByUserId(userId);
                userSuggestSettingModel.setDistricts(districtReferences.stream().map(
                        tbDistrictReference -> tbDistrictReference.getDistrictId())
                        .collect(Collectors.toList()));
                userResponseModel.setUserSuggestSettingModel(userSuggestSettingModel);
            }
        }
        List<UserRateResponseModel> userRateResponses = new ArrayList<>();
        if (userRates != null) {
            Double avgBehaviourRate = 0.0;
            Double avgLifeStyleRate = 0.0;
            Double avgPaymentRate = 0.0;

            int count = 0;
            for (TbUserRate tbUserRate: userRates) {
                if (count < 6) {
                    userRateResponses
                            .add(new UserRateResponseModel(tbUserRate,userService.findById(tbUserRate.getOwnerId())));
                    count++;
                }
                avgBehaviourRate += tbUserRate.getBehaviourRate();;
                avgLifeStyleRate += tbUserRate.getLifeStyleRate();;
                avgPaymentRate += tbUserRate.getPaymentRate();;
            }

            avgBehaviourRate = Double.parseDouble(Math.round((avgBehaviourRate / userRates.size()) * 10) + "");
            avgLifeStyleRate = Double.parseDouble(Math.round((avgLifeStyleRate / userRates.size()) * 10) + "");
            avgPaymentRate = Double.parseDouble(Math.round((avgPaymentRate / userRates.size()) * 10) + "");

            userResponseModel.setAvgBehaviourRate(avgBehaviourRate / 10);
            userResponseModel.setAvgLifeStyleRate(avgLifeStyleRate / 10);
            userResponseModel.setAvgPaymentRate(avgPaymentRate / 10);
        }

        userResponseModel.setUserRateResponseModels(userRateResponses);
        return userResponseModel;
    }

    public RoomPostResponseModel getRoomPostResponseModel(int userId,TbPost tbPost){
        RoomPostResponseModel roomPostResponseModel = new RoomPostResponseModel();
        TbRoom room = roomService.findRoomById(tbPost.getRoomId());
        List<TbRoomHasUtility> roomHasUtilities = roomHasUtilityService.findAllByRoomId(room.getRoomId());
//                    UserResponseModel userResponseModel = new UserResponseModel(userService.findById(tbPost.getUserId()));
        TbFavourite favourite = favouriteService
                .findByUserIdAndPostId(userId, tbPost.getPostId());
        roomPostResponseModel.setName(tbPost.getName());
        roomPostResponseModel.setPostId(tbPost.getPostId());
        roomPostResponseModel.setPhoneContact(tbPost.getPhoneContact());
        roomPostResponseModel.setDate(tbPost.getDatePost());

        UserResponseModel userResponseModel = new UserResponseModel();
        TbUser userDb = userService.findById(tbPost.getUserId());
        userResponseModel.setDob(userDb.getDob());
        userResponseModel.setPhone(userDb.getPhone());
        userResponseModel.setGender(userDb.getGender());
        userResponseModel.setUserId(userDb.getUserId());
        userResponseModel.setFullname(userDb.getFullname());
        userResponseModel.setImageProfile(userDb.getImageProfile());
//                    List<TbUserRate> userRates = userRateService.findAllByUserId(tbPost.getUserId());
//                    userResponseModel.setUserRateList(userRates);

        roomPostResponseModel.setUserResponseModel(userResponseModel);

        if (favourite != null) {
            roomPostResponseModel.setFavourite(true);
            roomPostResponseModel.setFavouriteId(favourite.getId());
        } else {
            roomPostResponseModel.setFavourite(false);
        }

        roomPostResponseModel.setMinPrice(tbPost.getMinPrice());//price for room post
        roomPostResponseModel.setAddress(room.getAddress());
        roomPostResponseModel.setArea(room.getArea());
        roomPostResponseModel.setGenderPartner(tbPost.getGenderPartner());
        roomPostResponseModel.setDescription(tbPost.getDescription());

        //missing
        List<TbImage> images = imageService.findAllByRoomId(room.getRoomId());
        roomPostResponseModel.setImageUrls(images
                .stream()
                .map(image -> image.getLinkUrl())
                .collect(Collectors.toList()));
        roomPostResponseModel.setUtilities(roomHasUtilities);
        roomPostResponseModel.setNumberPartner(tbPost.getNumberPartner());

        List<TbRoomRate> roomRateList = roomRateService.findAllByRoomId(tbPost.getRoomId());
        List<RoomRateResponseModel> roomRateResponseModels = new ArrayList<>();
        if (roomRateList != null) {
            Double avarageSecurity = 0.0;
            Double avarageLocation = 0.0;
            Double avarageUtility = 0.0;
            int count = 0;

            for (TbRoomRate tbRoomRate : roomRateList) {
                if (count < 6) {
                    roomRateResponseModels.add(new RoomRateResponseModel(tbRoomRate,userService.findById(tbRoomRate.getUserId())));
                    count++;
                }
                avarageSecurity += tbRoomRate.getSecurityRate();
                avarageLocation += tbRoomRate.getLocationRate();
                avarageUtility += tbRoomRate.getUtilityRate();
            }

            avarageSecurity = Double.parseDouble(Math.round((avarageSecurity / roomRateList.size()) * 10) + "");
            avarageLocation = Double.parseDouble(Math.round((avarageLocation / roomRateList.size()) * 10) + "");
            avarageUtility = Double.parseDouble(Math.round((avarageUtility / roomRateList.size()) * 10) + "");

            roomPostResponseModel.setAvarageSecurity(avarageSecurity / 10);
            roomPostResponseModel.setAvarageLocation(avarageLocation / 10);
            roomPostResponseModel.setAvarageUtility(avarageUtility / 10);
        }
        roomPostResponseModel.setRoomRateResponseModels(roomRateResponseModels);

        return roomPostResponseModel;
    }

    public RoomResponseModel getRoomResponseModel(int roomId){
        RoomResponseModel roomResponseModel = new RoomResponseModel();
        TbRoom room = roomService.findRoomById(roomId);
        TbUser roomOwner = userService.findById(room.getUserId());

        roomResponseModel.setRoomId(room.getRoomId());
        roomResponseModel.setName(room.getName());
        roomResponseModel.setPrice(room.getPrice());
        roomResponseModel.setArea(room.getArea());
        roomResponseModel.setAddress(room.getAddress());
        roomResponseModel.setMaxGuest(room.getMaxGuest());
        roomResponseModel.setCurrentMember(room.getCurrentNumber());
        roomResponseModel.setUserId(room.getUserId());
        roomResponseModel.setCityId(room.getCityId());
        roomResponseModel.setDistrictId(room.getDistrictId());
        roomResponseModel.setDateCreated(room.getDate());
        roomResponseModel.setStatusId(room.getStatusId());
        roomResponseModel.setDescription(room.getDescription());
        roomResponseModel.setLongitude(room.getLongtitude());
        roomResponseModel.setLatitude(room.getLattitude());
        roomResponseModel.setPhoneNumber(roomOwner.getPhone());
        roomResponseModel.setUtilities(roomHasUtilityService.findAllByRoomId(room.getRoomId()));
        roomResponseModel.setImageUrls(imageService.findAllByRoomId(room.getRoomId())
                .stream()
                .map(tbImage -> tbImage.getLinkUrl())
                .collect(Collectors.toList()));
        roomResponseModel.setMembers(roomHasUserService.findByRoomIdAndDateOutIsNull(room.getRoomId())
                .stream()
                .map(roomHasUser -> {
                    TbUser user = userService.findById(roomHasUser.getUserId());
                    return new MemberResponseModel(user.getUserId(), user.getRoleId()
                            , user.getUsername(), user.getPhone());
                }).collect(Collectors.toList()));

        List<TbRoomRate> roomRateList = roomRateService.findAllByRoomId(roomId);
        List<RoomRateResponseModel> roomRateResponseModels = new ArrayList<>();
        if (roomRateList != null) {
            Double avarageSecurity = 0.0;
            Double avarageLocation = 0.0;
            Double avarageUtility = 0.0;
            int count = 0;

            for (TbRoomRate tbRoomRate : roomRateList) {
                if (count < 6) {
                    roomRateResponseModels.add(new RoomRateResponseModel(tbRoomRate,userService.findById(tbRoomRate.getUserId())));
                    count++;
                }
                avarageSecurity += tbRoomRate.getSecurityRate();
                avarageLocation += tbRoomRate.getLocationRate();
                avarageUtility += tbRoomRate.getUtilityRate();
            }

            avarageSecurity = Double.parseDouble(Math.round((avarageSecurity / roomRateList.size()) * 10) + "");
            avarageLocation = Double.parseDouble(Math.round((avarageLocation / roomRateList.size()) * 10) + "");
            avarageUtility = Double.parseDouble(Math.round((avarageUtility / roomRateList.size()) * 10) + "");

            roomResponseModel.setAvarageSecurity(avarageSecurity / 10);
            roomResponseModel.setAvarageLocation(avarageLocation / 10);
            roomResponseModel.setAvarageUtility(avarageUtility / 10);
            roomResponseModel.setRoomRateResponseModels(roomRateResponseModels);
        }

        return roomResponseModel;
    }

    public Page<RoomRateResponseModel> getRoomRateResponseModels(int roomId,Pageable pageable){

        Page<TbRoomRate> roomRateList = roomRateService.findAllByRoomId(roomId,pageable);
        Page<RoomRateResponseModel> roomRateResponseModels = roomRateList.map(tbRoomRate -> new RoomRateResponseModel(tbRoomRate,userService.findById(tbRoomRate.getUserId())));
        return roomRateResponseModels;
    }
    public Page<UserRateResponseModel> getUserRateResponseModels(int userId,Pageable pageable){
        Page<TbUserRate> userRates = userRateService.findAllByUserIdOrderByDateDesc(userId,pageable);

        Page<UserRateResponseModel> userRateResponseModels = userRates.map(tbUserRate -> new UserRateResponseModel(tbUserRate,userService.findById(tbUserRate.getOwnerId())));
        return userRateResponseModels;
    }
    public RoommatePostResponseModel getRoommatePostResponseModel(int userId,TbPost tbPost){
        RoommatePostResponseModel roommatePostResponseModel = new RoommatePostResponseModel();
        TbFavourite favourite = favouriteService
                .findByUserIdAndPostId(userId, tbPost.getPostId());
        List<TbPostHasUtility> utilitiesReferences = postHasUtilityService.findAllByPostId(tbPost.getPostId());
        List<TbPostHasTbDistrict> districtReferences = postHasDistrictService.findAllByPostId(tbPost.getPostId());
        TbDistrict district = new TbDistrict();

        if (districtReferences != null && districtReferences.size() != 0) {
            roommatePostResponseModel.setDistrictIds(districtReferences
                    .stream()
                    .map(tbDistrictReference -> tbDistrictReference.getDistrictId())
                    .collect(Collectors.toList()));
            district = districtService.findByDistrictId(districtReferences.get(0).getDistrictId());
            roommatePostResponseModel.setCityId(district.getCityId());
        }

        if (utilitiesReferences != null && utilitiesReferences.size() != 0) {
            roommatePostResponseModel.setUtilityIds(utilitiesReferences
                    .stream()
                    .map(tbUtilitiesReference -> tbUtilitiesReference.getUtilityId())
                    .collect(Collectors.toList()));
        }

        roommatePostResponseModel.setPostId(tbPost.getPostId());
        roommatePostResponseModel.setPhoneContact(tbPost.getPhoneContact());
        roommatePostResponseModel.setDate(tbPost.getDatePost());

        roommatePostResponseModel.setUserResponseModel(this.getUserResponseModel(tbPost.getUserId(),false));

        if (favourite != null) {
            roommatePostResponseModel.setFavourite(true);
            roommatePostResponseModel.setFavouriteId(favourite.getId());
        } else {
            roommatePostResponseModel.setFavourite(false);
        }

        roommatePostResponseModel.setMinPrice(tbPost.getMinPrice());
        roommatePostResponseModel.setMaxPrice(tbPost.getMaxPrice());
        return roommatePostResponseModel;
    }

    public Page<RoomPostResponseModel> partnerPostSuggestion(Filter filter) {

        FilterArgumentModel filterArgumentModel = filter.getFilterArgumentModel();

        Page<TbPost> posts = postService.finAllByFilter(filterArgumentModel.getPage()
                , filterArgumentModel.getOffset(), filter);
        if (posts.getTotalElements() != 0) {
            Page<RoomPostResponseModel> roomPostResponseModels = posts.map(tbPost -> {
                RoomPostResponseModel roomPostResponseModel = new RoomPostResponseModel();

                TbRoom room = roomService.findRoomById(tbPost.getRoomId());
                List<TbRoomHasUtility> roomHasUtilities = roomHasUtilityService.findAllByRoomId(room.getRoomId());
//                UserResponseModel userResponseModel = new UserResponseModel(userService.findById(tbPost.getUserId()));
                TbFavourite favourite = favouriteService
                        .findByUserIdAndPostId(filter.getFilterArgumentModel().getUserId(), tbPost.getPostId());

                roomPostResponseModel.setName(tbPost.getName());
                roomPostResponseModel.setPostId(tbPost.getPostId());
                roomPostResponseModel.setPhoneContact(tbPost.getPhoneContact());
                roomPostResponseModel.setDate(tbPost.getDatePost());

                UserResponseModel userResponseModel = new UserResponseModel();
                TbUser userDb = userService.findById(tbPost.getUserId());
                userResponseModel.setDob(userDb.getDob());
                userResponseModel.setPhone(userDb.getPhone());
                userResponseModel.setGender(userDb.getGender());
                userResponseModel.setUserId(userDb.getUserId());
                userResponseModel.setFullname(userDb.getFullname());
                userResponseModel.setImageProfile(userDb.getImageProfile());
//                List<TbUserRate> userRates = userRateService.findAllByUserId(tbPost.getUserId());
//
//                userResponseModel.setUserRateList(userRates);

                roomPostResponseModel.setUserResponseModel(userResponseModel);

                if (favourite != null) {
                    roomPostResponseModel.setFavouriteId(favourite.getId());
                    roomPostResponseModel.setFavourite(true);
                } else {
                    roomPostResponseModel.setFavourite(false);
                }

                roomPostResponseModel.setMinPrice(tbPost.getMinPrice());//price for room post
                roomPostResponseModel.setAddress(room.getAddress());
                roomPostResponseModel.setArea(room.getArea());
                roomPostResponseModel.setGenderPartner(tbPost.getGenderPartner());
                roomPostResponseModel.setDescription(tbPost.getDescription());
                //missing
                List<TbImage> images = imageService.findAllByRoomId(room.getRoomId());
                roomPostResponseModel.setImageUrls(images
                        .stream()
                        .map(image -> image.getLinkUrl())
                        .collect(Collectors.toList()));

                roomPostResponseModel.setUtilities(roomHasUtilities);
                roomPostResponseModel.setNumberPartner(tbPost.getNumberPartner());

                List<TbRoomRate> roomRateList = roomRateService.findAllByRoomId(tbPost.getRoomId());
                List<RoomRateResponseModel> roomRateResponseModels = new ArrayList<>();
                if (roomRateList != null) {
                    Double avarageSecurity = 0.0;
                    Double avarageLocation = 0.0;
                    Double avarageUtility = 0.0;
                    int count = 0;

                    for (TbRoomRate tbRoomRate : roomRateList) {
                        if (count < 6) {

                            roomRateResponseModels.add(new RoomRateResponseModel(tbRoomRate,userService.findById(tbRoomRate.getUserId())));
                            count++;
                        }
                        avarageSecurity += tbRoomRate.getSecurityRate();
                        avarageLocation += tbRoomRate.getLocationRate();
                        avarageUtility += tbRoomRate.getUtilityRate();
                    }

                    avarageSecurity = Double.parseDouble(Math.round((avarageSecurity / roomRateList.size()) * 10) + "");
                    avarageLocation = Double.parseDouble(Math.round((avarageLocation / roomRateList.size()) * 10) + "");
                    avarageUtility = Double.parseDouble(Math.round((avarageUtility / roomRateList.size()) * 10) + "");

                    roomPostResponseModel.setAvarageSecurity(avarageSecurity / 10);
                    roomPostResponseModel.setAvarageLocation(avarageLocation / 10);
                    roomPostResponseModel.setAvarageUtility(avarageUtility / 10);
                }
                roomPostResponseModel.setRoomRateResponseModels(roomRateResponseModels);
                return roomPostResponseModel;
            });

            return roomPostResponseModels;
        }
        return null;
    }

    public Page<RoomPostResponseModel> getNewPost(BaseSuggestRequestModel baseSuggestRequestModel) {
        FilterArgumentModel filterArgumentModel = new FilterArgumentModel();
        filterArgumentModel.setOrderBy(NEWPOST);
        filterArgumentModel.setPage(baseSuggestRequestModel.getPage());
        filterArgumentModel.setOffset(baseSuggestRequestModel.getOffset());
        filterArgumentModel.setTypeId(baseSuggestRequestModel.getTypeId());
        filterArgumentModel.setCityId(baseSuggestRequestModel.getCityId());
        filterArgumentModel.setUserId(baseSuggestRequestModel.getUserId());
        Filter filter = new Filter();
        filter.setFilterArgumentModel(filterArgumentModel);
        Page<RoomPostResponseModel> roomPostResponseModels = partnerPostSuggestion(filter);
        return roomPostResponseModels;
    }

    public List<RoomPostResponseModel> mappingRoomPost(List<TbPost> postList, List<RoomPostResponseModel> roomPostResponseModels, int userId) {
        for (TbPost tbPost : postList) {

            RoomPostResponseModel roomPostResponseModel = new RoomPostResponseModel();

            TbRoom room = roomService.findRoomById(tbPost.getRoomId());
            List<TbRoomHasUtility> roomHasUtilities = roomHasUtilityService.findAllByRoomId(room.getRoomId());
            TbFavourite favourite = favouriteService
                    .findByUserIdAndPostId(userId, tbPost.getPostId());

            roomPostResponseModel.setName(tbPost.getName());
            roomPostResponseModel.setPostId(tbPost.getPostId());
            roomPostResponseModel.setPhoneContact(tbPost.getPhoneContact());
            roomPostResponseModel.setDate(tbPost.getDatePost());

            UserResponseModel userResponseModel = new UserResponseModel();
            TbUser userDb = userService.findById(tbPost.getUserId());
            userResponseModel.setDob(userDb.getDob());
            userResponseModel.setPhone(userDb.getPhone());
            userResponseModel.setGender(userDb.getGender());
            userResponseModel.setUserId(userDb.getUserId());
            userResponseModel.setFullname(userDb.getFullname());
            userResponseModel.setImageProfile(userDb.getImageProfile());
//            List<TbUserRate> userRates = userRateService.findAllByUserId(tbPost.getUserId());
//            userResponseModel.setUserRateList(userRates);

            roomPostResponseModel.setUserResponseModel(userResponseModel);
            if (favourite != null) {
                roomPostResponseModel.setFavourite(true);
                roomPostResponseModel.setFavouriteId(favourite.getId());
            } else {
                roomPostResponseModel.setFavourite(false);
            }
            roomPostResponseModel.setMinPrice(tbPost.getMinPrice());//price for room post
            roomPostResponseModel.setAddress(room.getAddress());
            roomPostResponseModel.setArea(room.getArea());
            roomPostResponseModel.setGenderPartner(tbPost.getGenderPartner());
            roomPostResponseModel.setDescription(tbPost.getDescription());
            //missing
            List<TbImage> images = imageService.findAllByRoomId(room.getRoomId());
            roomPostResponseModel.setImageUrls(images
                    .stream()
                    .map(image -> image.getLinkUrl())
                    .collect(Collectors.toList()));

            roomPostResponseModel.setUtilities(roomHasUtilities);
            roomPostResponseModel.setNumberPartner(tbPost.getNumberPartner());

            List<TbRoomRate> roomRateList = roomRateService.findAllByRoomId(tbPost.getRoomId());
            List<RoomRateResponseModel> roomRateResponseModels = new ArrayList<>();
            if (roomRateList != null) {
                Double avarageSecurity = 0.0;
                Double avarageLocation = 0.0;
                Double avarageUtility = 0.0;
                int count = 0;

                for (TbRoomRate tbRoomRate : roomRateList) {
                    if (count < 6) {
                        roomRateResponseModels.add(new RoomRateResponseModel(tbRoomRate,userService.findById(tbRoomRate.getUserId())));
                        count++;
                    }
                    avarageSecurity += tbRoomRate.getSecurityRate();
                    avarageLocation += tbRoomRate.getLocationRate();
                    avarageUtility += tbRoomRate.getUtilityRate();
                }

                avarageSecurity = Double.parseDouble(Math.round((avarageSecurity / roomRateList.size()) * 10) + "");
                avarageLocation = Double.parseDouble(Math.round((avarageLocation / roomRateList.size()) * 10) + "");
                avarageUtility = Double.parseDouble(Math.round((avarageUtility / roomRateList.size()) * 10) + "");

                roomPostResponseModel.setAvarageSecurity(avarageSecurity / 10);
                roomPostResponseModel.setAvarageLocation(avarageLocation / 10);
                roomPostResponseModel.setAvarageUtility(avarageUtility / 10);
            }
            roomPostResponseModel.setRoomRateResponseModels(roomRateResponseModels);
            roomPostResponseModels.add(roomPostResponseModel);
        }
        return roomPostResponseModels;
    }
}
