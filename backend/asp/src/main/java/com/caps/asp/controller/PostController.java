package com.caps.asp.controller;

import com.caps.asp.model.*;
import com.caps.asp.model.uimodel.request.FilterArgumentModel;
import com.caps.asp.model.uimodel.request.FilterRequestModel;
import com.caps.asp.model.uimodel.request.SearchRequestModel;
import com.caps.asp.model.uimodel.request.post.RoomPostRequestModel;
import com.caps.asp.model.uimodel.request.post.RoommatePostRequestModel;
import com.caps.asp.model.uimodel.request.common.BaseSuggestRequestModel;
import com.caps.asp.model.uimodel.response.common.*;
import com.caps.asp.model.uimodel.response.post.RoomPostResponseModel;
import com.caps.asp.model.uimodel.response.post.RoommatePostResponseModel;
import com.caps.asp.service.*;
import com.caps.asp.service.filter.BookmarkFilter;
import com.caps.asp.service.filter.Filter;
import com.caps.asp.service.UtilsService;
import com.caps.asp.service.filter.Search;
import com.caps.asp.util.GoogleAPI;
import com.google.maps.model.GeocodingResult;
import org.springframework.data.domain.*;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.xml.ws.Response;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

import static com.caps.asp.constant.Constant.*;
import static org.springframework.http.HttpStatus.*;

@RestController
public class PostController {
    public final PostService postService;
    public final RoomService roomService;
    public final UserService userService;
    public final RoomHasUserService roomHasUserService;
    public final RoomHasUtilityService roomHasUtilityService;
    public final ImageService imageService;
    public final FavouriteService favouriteService;
    public final DistrictService districtService;
    public final UtilityReferenceService utilityReferenceService;
    public final DistrictReferenceService districtReferenceService;
    public final ReferenceService referenceService;
    public final UtilsService utilsService;
    public final CityService cityService;
    public final PostHasUtilityService postHasUtilityService;
    public final PostHasDistrictService postHasDistrictService;
    public final UserRateService userRateService;
    public final RoomRateService roomRateService;

    public PostController(PostService postService, RoomService roomService, UserService userService, RoomHasUserService roomHasUserService, RoomHasUtilityService roomHasUtilityService, ImageService imageService, FavouriteService favouriteService, DistrictService districtService, UtilityReferenceService utilityReferenceService, DistrictReferenceService districtReferenceService, ReferenceService referenceService, UtilsService utilsService, CityService cityService, PostHasUtilityService postHasUtilityService, PostHasDistrictService postHasDistrictService, UserRateService userRateService, RoomRateService roomRateService) {
        this.postService = postService;
        this.roomService = roomService;
        this.userService = userService;
        this.roomHasUserService = roomHasUserService;
        this.roomHasUtilityService = roomHasUtilityService;
        this.imageService = imageService;
        this.favouriteService = favouriteService;
        this.districtService = districtService;
        this.utilityReferenceService = utilityReferenceService;
        this.districtReferenceService = districtReferenceService;
        this.referenceService = referenceService;
        this.utilsService = utilsService;
        this.cityService = cityService;
        this.postHasUtilityService = postHasUtilityService;
        this.postHasDistrictService = postHasDistrictService;
        this.userRateService = userRateService;
        this.roomRateService = roomRateService;
    }

    @PostMapping("/post/userPost")
    public ResponseEntity getPost(@RequestBody FilterArgumentModel filterArgumentModel) {
        try {
            //filter nay co page, offset, user id, typeid la co gia tri
            //search response model  = null
            //can mapping to Roommate response model va room response model
//        Page<TbPost> posts = postService.findAllByUserId(Integer.parseInt(page), 10, userId);
            if (filterArgumentModel.getTypeId() == MEMBER_POST) {//get member post
                Page<TbPost> posts = postService.findByUserIdAndTypeId(filterArgumentModel.getPage(), filterArgumentModel.getOffset(),
                        filterArgumentModel.getUserId(), filterArgumentModel.getTypeId());

                Page<RoommatePostResponseModel> roommatePostResponseModels = posts.map(tbPost -> utilsService.getRoommatePostResponseModel(filterArgumentModel.getUserId(),tbPost));
                return ResponseEntity.status(OK).body(roommatePostResponseModels.getContent());
            } else {
                Page<TbPost> posts = postService.findByUserIdAndTypeId(filterArgumentModel.getPage(), filterArgumentModel.getOffset(),
                        filterArgumentModel.getUserId(), filterArgumentModel.getTypeId());
                Page<RoomPostResponseModel> roomPostResponseModels = posts.map(tbPost ->
                    utilsService.getRoomPostResponseModel(filterArgumentModel.getUserId(),tbPost)
                );
                return ResponseEntity.status(OK).body(roomPostResponseModels.getContent());
            }
        } catch (Exception e) {
            return ResponseEntity.status(NOT_FOUND).build();
        }
    }

    @Transactional
    @PostMapping("/post/createRoommatePost")
    public ResponseEntity createRoommatePost(@RequestBody RoommatePostRequestModel roommatePostRequestModel) {
        try {
            TbUser user = userService.findById(roommatePostRequestModel.getUserId());
            if (user.getRoleId() == MEMBER || user.getRoleId() == ROOM_MASTER) {
                TbPost post = new TbPost();
                Date date = new Date(System.currentTimeMillis());

                Timestamp timestamp = new Timestamp(System.currentTimeMillis());
                post.setPostId(0);
                post.setDatePost(timestamp);
                post.setName(user.getUsername());

                post.setPhoneContact(roommatePostRequestModel.getPhoneContact());
                post.setTypeId(MEMBER_POST);
                post.setUserId(user.getUserId());
                post.setMaxPrice(roommatePostRequestModel.getMaxPrice());
                post.setMinPrice(roommatePostRequestModel.getMinPrice());
                int postId = postService.savePost(post);

                TbReference reference = referenceService.getByUserId(user.getUserId());
                if (reference != null) {
                    reference.setMaxPrice(roommatePostRequestModel.getMaxPrice());
                    reference.setMinPrice(roommatePostRequestModel.getMinPrice());
                    referenceService.save(reference);
                } else {
                    TbReference tbReference = new TbReference();
                    tbReference.setMaxPrice(roommatePostRequestModel.getMaxPrice());
                    tbReference.setMinPrice(roommatePostRequestModel.getMinPrice());
                    tbReference.setUserId(roommatePostRequestModel.getUserId());
                    referenceService.save(tbReference);
                }

                utilityReferenceService.removeAllByUserId(user.getUserId());

                for (Integer utilityId : roommatePostRequestModel.getUtilityIds()) {
                    TbPostHasUtility postHasUtility = new TbPostHasUtility();
                    postHasUtility.setId(0);
                    postHasUtility.setPostId(postId);
                    postHasUtility.setUtilityId(utilityId);
                    postHasUtilityService.save(postHasUtility);

                    TbUtilitiesReference utilitiesReference = new TbUtilitiesReference();
                    utilitiesReference.setId(0);
                    utilitiesReference.setUserId(user.getUserId());
                    utilitiesReference.setUtilityId(utilityId);
                    utilityReferenceService.save(utilitiesReference);
                }

                districtReferenceService.removeAllByUserId(user.getUserId());

                for (Integer districtId : roommatePostRequestModel.getDistrictIds()) {
                    TbPostHasTbDistrict postHasTbDistrict = new TbPostHasTbDistrict();
                    postHasTbDistrict.setId(0);
                    postHasTbDistrict.setPostId(postId);
                    postHasTbDistrict.setDistrictId(districtId);
                    postHasDistrictService.save(postHasTbDistrict);

                    TbDistrictReference districtReference = new TbDistrictReference();
                    districtReference.setId(0);
                    districtReference.setUserId(user.getUserId());
                    districtReference.setDistrictId(districtId);
                    districtReferenceService.save(districtReference);
                }
                return ResponseEntity.status(CREATED).build();
            }
            return ResponseEntity.status(CONFLICT).build();
        } catch (Exception e) {
            return ResponseEntity.status(CONFLICT).build();
        }
    }

    @Transactional
    @PutMapping("/post/updateRoommatePost")
    public ResponseEntity updateRoommatePost(@RequestBody RoommatePostRequestModel roommatePostRequestModel) {
        try {
            TbUser user = userService.findById(roommatePostRequestModel.getUserId());
            TbPost post = postService.findByPostId(roommatePostRequestModel.getPostId());
            if (post != null && post.getTypeId() == MEMBER_POST
                    && post.getUserId().equals(roommatePostRequestModel.getUserId())) {

                post.setPhoneContact(roommatePostRequestModel.getPhoneContact());
                post.setMaxPrice(roommatePostRequestModel.getMaxPrice());
                post.setMinPrice(roommatePostRequestModel.getMinPrice());
                int postId = postService.savePost(post);
                TbPost newestPost = postService.findAllByUserIdAndTypeIdOrderByDatePostDesc(roommatePostRequestModel.getUserId(),
                        MEMBER_POST);

                postHasDistrictService.removeAllByPostId(roommatePostRequestModel.getPostId());
                postHasUtilityService.deleteAllPostHasUtilityByPostId(roommatePostRequestModel.getPostId());
                if (newestPost.getPostId().equals(roommatePostRequestModel.getPostId())) {



                    TbReference reference = referenceService.getByUserId(user.getUserId());
                    reference.setMaxPrice(roommatePostRequestModel.getMaxPrice());
                    reference.setMinPrice(roommatePostRequestModel.getMinPrice());
                    referenceService.save(reference);

                    utilityReferenceService.removeAllByUserId(user.getUserId());


                    for (Integer utilityId : roommatePostRequestModel.getUtilityIds()) {
                        TbPostHasUtility postHasUtility = new TbPostHasUtility();
                        postHasUtility.setId(0);
                        postHasUtility.setPostId(postId);
                        postHasUtility.setUtilityId(utilityId);
                        postHasUtilityService.save(postHasUtility);

                        TbUtilitiesReference utilitiesReference = new TbUtilitiesReference();
                        utilitiesReference.setId(0);
                        utilitiesReference.setUserId(user.getUserId());
                        utilitiesReference.setUtilityId(utilityId);
                        utilityReferenceService.save(utilitiesReference);
                    }

                    districtReferenceService.removeAllByUserId(user.getUserId());

                    for (Integer districtId : roommatePostRequestModel.getDistrictIds()) {
                        TbPostHasTbDistrict postHasTbDistrict = new TbPostHasTbDistrict();
                        postHasTbDistrict.setId(0);
                        postHasTbDistrict.setPostId(postId);
                        postHasTbDistrict.setDistrictId(districtId);
                        postHasDistrictService.save(postHasTbDistrict);

                        TbDistrictReference districtReference = new TbDistrictReference();
                        districtReference.setId(0);
                        districtReference.setUserId(user.getUserId());
                        districtReference.setDistrictId(districtId);
                        districtReferenceService.save(districtReference);
                    }

                } else {



                    for (Integer utilityId : roommatePostRequestModel.getUtilityIds()) {
                        TbPostHasUtility postHasUtility = new TbPostHasUtility();
                        postHasUtility.setId(0);
                        postHasUtility.setPostId(post.getPostId());
                        postHasUtility.setUtilityId(utilityId);
                        postHasUtilityService.save(postHasUtility);
                    }

                    for (Integer districtId : roommatePostRequestModel.getDistrictIds()) {
                        TbPostHasTbDistrict postHasTbDistrict = new TbPostHasTbDistrict();
                        postHasTbDistrict.setId(0);
                        postHasTbDistrict.setPostId(post.getPostId());
                        postHasTbDistrict.setDistrictId(districtId);
                        postHasDistrictService.save(postHasTbDistrict);
                    }
                }
                return ResponseEntity.status(OK).build();
            }
            return ResponseEntity.status(CONFLICT).build();
        } catch (Exception e) {
            return ResponseEntity.status(CONFLICT).build();
        }
    }

    @PostMapping("/post/createRoomPost")
    public ResponseEntity createRoomPost(@RequestBody RoomPostRequestModel roomPostRequestModel) {
        try {
            TbUser user = userService.findById(roomPostRequestModel.getUserId());
            TbRoom room = roomService.findRoomById(roomPostRequestModel.getRoomId());
            TbRoomHasUser roomHasUser = roomHasUserService.findByUserIdAndRoomIdAndDateOutIsNull(user.getUserId(), room.getRoomId());

            if (user.getRoleId() == ROOM_MASTER && roomHasUser != null) {
                TbPost post = new TbPost();
                post.setTypeId(MASTER_POST);
                post.setLongtitude(room.getLongtitude());
                post.setLattitude(room.getLattitude());
                Timestamp timestamp = new Timestamp(System.currentTimeMillis());
                post.setDatePost(timestamp);
                post.setNumberPartner(roomPostRequestModel.getNumberPartner());
                post.setPhoneContact(roomPostRequestModel.getPhoneContact());
                post.setName(roomPostRequestModel.getName());
                post.setMinPrice(roomPostRequestModel.getMinPrice());
                post.setRoomId(roomPostRequestModel.getRoomId());
                post.setGenderPartner(roomPostRequestModel.getGenderPartner());
                post.setDescription(roomPostRequestModel.getDescription());
                post.setUserId(roomPostRequestModel.getUserId());
                post.setPostId(0);

                int postId = postService.savePost(post);
                List<TbRoomHasUtility> roomHasUtilities = roomHasUtilityService.findAllByRoomId(roomPostRequestModel.getRoomId());

                for (TbRoomHasUtility tbRoomHasUtility : roomHasUtilities) {
                    TbPostHasUtility postHasUtility = new TbPostHasUtility();
                    postHasUtility.setId(0);
                    postHasUtility.setPostId(postId);
                    postHasUtility.setUtilityId(tbRoomHasUtility.getUtilityId());
                    postHasUtility.setBrand(tbRoomHasUtility.getBrand());
                    postHasUtility.setQuantity(tbRoomHasUtility.getQuantity());
                    postHasUtility.setDescription(tbRoomHasUtility.getDescription());
                    postHasUtilityService.save(postHasUtility);
                }

                TbPostHasTbDistrict tbPostHasTbDistrict = new TbPostHasTbDistrict();
                tbPostHasTbDistrict.setDistrictId(roomService
                        .findRoomById(roomPostRequestModel.getRoomId())
                        .getDistrictId());
                tbPostHasTbDistrict.setPostId(postId);
                tbPostHasTbDistrict.setId(0);
                postHasDistrictService.save(tbPostHasTbDistrict);
                return ResponseEntity.status(CREATED).build();
            } else {
                return ResponseEntity.status(CONFLICT).build();
            }
        } catch (Exception e) {
            return ResponseEntity.status(CONFLICT).build();
        }
    }

    @PutMapping("/post/updateRoomPost")
    public ResponseEntity updateRoomPost(@RequestBody RoomPostRequestModel roomPostRequestModel) {
        try {

            TbPost post = postService.findByPostId(roomPostRequestModel.getPostId());
            TbRoom room = roomService.findRoomById(post.getRoomId());
            if(room!=null){
                if (post != null && post.getTypeId() == MASTER_POST
                        && post.getUserId().equals(roomPostRequestModel.getUserId())) {

                    post.setLongtitude(room.getLongtitude());
                    post.setLattitude(room.getLattitude());
                    post.setNumberPartner(roomPostRequestModel.getNumberPartner());
                    post.setPhoneContact(roomPostRequestModel.getPhoneContact());
                    post.setName(roomPostRequestModel.getName());
                    post.setGenderPartner(roomPostRequestModel.getGenderPartner());
                    post.setDescription(roomPostRequestModel.getDescription());
                    postService.savePost(post);
                    return ResponseEntity.status(OK).build();
                }
                return ResponseEntity.status(CONFLICT).build();
            }
            return ResponseEntity.status(NOT_FOUND).build();
        } catch (Exception e) {
            return ResponseEntity.status(CONFLICT).build();
        }
    }

    @Transactional
    @DeleteMapping("/post/delete/{postId}")
    public ResponseEntity deletePost(@PathVariable int postId) {
        try {
            postHasDistrictService.removeAllByPostId(postId);
            postHasUtilityService.deleteAllPostHasUtilityByPostId(postId);
            favouriteService.removeAllByPostId(postId);
            postService.removeByPostId(postId);
            return ResponseEntity.status(OK).build();
        } catch (Exception e) {
            return ResponseEntity.status(CONFLICT).build();
        }
    }

    @PostMapping("/post/filter")
    public ResponseEntity getPostByFilter(@RequestBody FilterArgumentModel filterArgumentModel) {
//        try {
            Filter filter = new Filter();
            filter.setFilterArgumentModel(filterArgumentModel);

            Page<TbPost> posts = postService.finAllByFilter(filterArgumentModel.getPage()
                    , filterArgumentModel.getOffset(), filter);
            if (filter.getFilterArgumentModel().getTypeId() == MEMBER_POST) {//get member post
                Page<RoommatePostResponseModel> roommatePostResponseModels = posts.map(tbPost ->utilsService.getRoommatePostResponseModel(filterArgumentModel.getUserId(),tbPost));
                return ResponseEntity.status(OK).body(roommatePostResponseModels.getContent());
            } else if (filter.getFilterArgumentModel().getTypeId() == MASTER_POST) {//get room master post
                Page<RoomPostResponseModel> roomPostResponseModels = posts.map(tbPost -> utilsService.getRoomPostResponseModel(filterArgumentModel.getUserId(),tbPost));
                return ResponseEntity.status(OK).body(roomPostResponseModels.getContent());
            }
            return ResponseEntity.status(NOT_FOUND).build();
//        } catch (Exception e) {
//            return ResponseEntity.status(NOT_FOUND).build();
//        }
    }

    @PostMapping("/post/favouriteFilter")
    public ResponseEntity getFavouriteByFilter(@RequestBody FilterArgumentModel filterArgumentModel) {
        try {
            BookmarkFilter filter = new BookmarkFilter();
            filter.setFilterArgumentModel(filterArgumentModel);

            if (filter.getFilterArgumentModel().getTypeId() == MEMBER_POST) {//get member post
                Page<TbPost> posts = postService.finAllBookmarkByFilter(filterArgumentModel.getPage()
                        , filterArgumentModel.getOffset(), filter);
                Page<RoommatePostResponseModel> roommatePostResponseModels = posts.map(tbPost ->utilsService.getRoommatePostResponseModel(filterArgumentModel.getUserId(),tbPost));
                return ResponseEntity.status(OK).body(roommatePostResponseModels.getContent());
            } else if (filter.getFilterArgumentModel().getTypeId() == MASTER_POST) {//get room master post
                Page<TbPost> posts = postService.finAllBookmarkByFilter(filterArgumentModel.getPage()
                        , filterArgumentModel.getOffset(), filter);
                Page<RoomPostResponseModel> roomPostResponseModels =  posts.map(tbPost -> utilsService.getRoomPostResponseModel(filterArgumentModel.getUserId(),tbPost));
                return ResponseEntity.status(OK).body(roomPostResponseModels.getContent());
            }
            return ResponseEntity.status(NOT_FOUND).build();
        } catch (Exception e) {
            return ResponseEntity.status(NOT_FOUND).build();
        }
    }

    @PostMapping("/post/suggest")
    public ResponseEntity suggestPost(@RequestBody BaseSuggestRequestModel baseSuggestRequestModel) {
        try {

            TbUser tbUser = userService.findById(baseSuggestRequestModel.getUserId());
            System.out.println("Suggest For user: "+tbUser.getUsername()+" with name : "+tbUser.getFullname());

            TbPost checkPost = postService.findAllByUserIdAndTypeIdOrderByDatePostDesc(baseSuggestRequestModel.getUserId(), MASTER_POST);
            boolean checkDate = false;
            if (checkPost != null) {
                TbRoomHasUser roomHasUser = roomHasUserService
                        .findByUserIdAndRoomIdAndDateOutIsNull(baseSuggestRequestModel.getUserId(), checkPost.getRoomId());
                if (roomHasUser!=null){
                    checkDate = checkPost.getDatePost().getTime() > roomHasUser.getDateIn().getTime();
                }
            }

            //sugesst for room master
            if (tbUser.getRoleId() == ROOM_MASTER
                    && checkDate) {
                System.out.println("User is Room master suggest post nearby");
                List<TbPost> postList = postService.getSuggestedList(baseSuggestRequestModel.getUserId()
                        , baseSuggestRequestModel.getPage(), baseSuggestRequestModel.getOffset());

                if (postList == null || postList.size() == 0) {
                    return ResponseEntity
                            .status(OK)
                            .body(utilsService.getNewPost(baseSuggestRequestModel)
                                    .getContent());
                }

                List<RoomPostResponseModel> roomPostResponseModels = new ArrayList<>();
                return ResponseEntity.status(OK).body(utilsService.mappingRoomPost(postList, roomPostResponseModels, baseSuggestRequestModel.getUserId()));
            } else if (referenceService.getByUserId(baseSuggestRequestModel.getUserId()) != null) {//sugesst for room master
                System.out.println("User has reference so suggest by reference");
                FilterRequestModel filterRequestModel = new FilterRequestModel();
                List<TbUtilitiesReference> utilitiesReference = utilityReferenceService
                        .findAllByUserId(baseSuggestRequestModel.getUserId());
                List<Integer> utilityIds = utilitiesReference
                        .stream()
                        .map(tbUtilitiesReference -> tbUtilitiesReference.getUtilityId())
                        .collect(Collectors.toList());
                filterRequestModel.setUtilities(utilityIds);

                List<TbDistrictReference> districtReferences = districtReferenceService
                        .findAllByUserId(baseSuggestRequestModel.getUserId());
                List<Integer> districtIds = districtReferences
                        .stream()
                        .map(tbDistrictReference -> tbDistrictReference.getDistrictId())
                        .collect(Collectors.toList());
                filterRequestModel.setDistricts(districtIds);

                TbReference reference = referenceService.getByUserId(baseSuggestRequestModel.getUserId());
                List<Double> price = new ArrayList<>();
                price.add(reference.getMinPrice());
                price.add(reference.getMaxPrice());
                filterRequestModel.setPrice(price);

                FilterArgumentModel filterArgumentModel = new FilterArgumentModel();
                filterArgumentModel.setTypeId(baseSuggestRequestModel.getTypeId());
                filterArgumentModel.setPage(baseSuggestRequestModel.getPage());
                filterArgumentModel.setOffset(baseSuggestRequestModel.getOffset());
                filterArgumentModel.setOrderBy(NEWPOST);
                filterArgumentModel.setUserId(baseSuggestRequestModel.getUserId());
                filterArgumentModel.setCityId(baseSuggestRequestModel.getCityId());
                filterArgumentModel.setFilterRequestModel(filterRequestModel);

                Filter filter = new Filter();
                filter.setFilterArgumentModel(filterArgumentModel);
                Page<RoomPostResponseModel> roomPostResponseModels = utilsService.partnerPostSuggestion(filter);
                if (roomPostResponseModels == null) {
                    return ResponseEntity
                            .status(OK)
                            .body(utilsService.getNewPost(baseSuggestRequestModel)
                                    .getContent());
                }
                return ResponseEntity.status(OK).body(roomPostResponseModels.getContent());
            } else if (baseSuggestRequestModel.getLatitude() == null
                    && baseSuggestRequestModel.getLongitude() == null) { //not access location, common new post
                System.out.println("User hasn't logitude and latitude suggest new post");
                Page<RoomPostResponseModel> roomPostResponseModels = utilsService.getNewPost(baseSuggestRequestModel);
                return ResponseEntity.status(OK).body(roomPostResponseModels.getContent());
            } else { //access location, common nearby post
                System.out.println("User has logitude and latitude suggest nearby location of user");
                GoogleAPI googleAPI = new GoogleAPI();

                GeocodingResult geocodingResult = googleAPI.getLocationName(baseSuggestRequestModel.getLatitude(), baseSuggestRequestModel.getLongitude());

                String cityName = googleAPI.getCity(geocodingResult);
                TbCity city = cityService.findByNameLike(cityName);
//                Optional<TbCity> optionalTbCity = cityService.findAll().stream().filter(tbCity -> geocodingResult.formattedAddress.toLowerCase().contains(tbCity.getName().toLowerCase())).findFirst();
//                System.out.println("CityNameRequest:"+city.getName());

                System.out.println("Longitute:"+baseSuggestRequestModel.getLongitude());
                System.out.println("Latitude:"+baseSuggestRequestModel.getLatitude());
                if(city!=null) {
                    System.out.println("CityNameFound:"+city.getName());
                    int cityId = city.getCityId();
                    List<TbPost> postList = postService.getSuggestedListForMember(Float.parseFloat(baseSuggestRequestModel.getLatitude().toString())
                            , Float.parseFloat(baseSuggestRequestModel.getLongitude().toString())
                            , cityId
                            , baseSuggestRequestModel.getPage(), baseSuggestRequestModel.getOffset());

                    if (postList == null || postList.size() == 0) {
                        return ResponseEntity
                                .status(OK)
                                .body(utilsService.getNewPost(baseSuggestRequestModel)
                                        .getContent());
                    }

                    List<RoomPostResponseModel> roomPostResponseModels = new ArrayList<>();
                    return ResponseEntity
                            .status(OK)
                            .body(utilsService.mappingRoomPost(postList, roomPostResponseModels
                                    , baseSuggestRequestModel.getUserId()));
                }else{
                    Page<RoomPostResponseModel> roomPostResponseModels = utilsService.getNewPost(baseSuggestRequestModel);
                    return ResponseEntity.status(OK).body(roomPostResponseModels.getContent());
                }
            }
        } catch (Exception e) {
            return ResponseEntity.status(NOT_FOUND).build();
        }
    }
    @GetMapping("post/room/{postId}")
    public ResponseEntity getRoomByPostId(@PathVariable int postId){
        try {
            TbPost tbPost = postService.findByPostId(postId);
            if(tbPost!= null){
                return ResponseEntity.status(OK).body(utilsService.getRoomResponseModel(tbPost.getRoomId()));
            }
            return ResponseEntity.status(NOT_FOUND).build();
        } catch (Exception e) {
            return ResponseEntity.status(NOT_FOUND).build();
        }
    }

    @PostMapping("post/search")
    public ResponseEntity search(@RequestBody SearchRequestModel searchRequestModel) {
        try {
            Search search = new Search();
            search.setSearch(searchRequestModel.getAddress()
                    .trim()
                    .replaceAll("Việt Nam", "")
                    .split(","));

            List<TbRoom> roomList = roomService.findByLikeAddress(search);
            List<TbPost> postList = new ArrayList<>();
            SearchResponseModel searchResponseModel = new SearchResponseModel();
            roomList.forEach(tbRoom -> {
                int roomId = tbRoom.getRoomId();
                List<TbRoomHasUser> roomHasUser = roomHasUserService.getAllByRoomId(roomId);
                roomHasUser.forEach(tbRoomHasUser -> {
                    TbUser user = userService.findById(tbRoomHasUser.getUserId());
                    if (user.getRoleId() == ROOM_MASTER) {
                        TbPost post = postService
                                .findAllByUserIdAndRoomIdOrderByDatePostDesc(user.getUserId(), roomId);
                        if (post != null) {
                            postList.add(post);
                        }
                    }
                });
            });
            List<RoomPostResponseModel> roomPostResponseModels = new ArrayList<>();
            roomPostResponseModels = utilsService.mappingRoomPost(postList, roomPostResponseModels, searchRequestModel.getUserId());
            searchResponseModel.setRoomPostResponseModel(roomPostResponseModels);

            GoogleAPI googleAPI = new GoogleAPI();
            GeocodingResult geocodingResult = googleAPI.getLocationName(searchRequestModel.getLatitude(), searchRequestModel.getLongitude());

            String city = googleAPI.getCity(geocodingResult);
            int cityId = cityService.findByNameLike(city).getCityId();

            List<TbPost> nearByPostList = postService.getSuggestedListForMember(Float.parseFloat(searchRequestModel.getLatitude() + "")
                    , Float.parseFloat(searchRequestModel.getLongitude() + "")
                    , cityId
                    , 1, 20);

            nearByPostList.removeAll(postList);
            List<RoomPostResponseModel> nearByRoomPostResponseModels = new ArrayList<>();
            nearByRoomPostResponseModels = utilsService.mappingRoomPost(nearByPostList, nearByRoomPostResponseModels, searchRequestModel.getUserId());
            searchResponseModel.setNearByRoomPostResponseModels(nearByRoomPostResponseModels);
            return ResponseEntity.status(OK).body(searchResponseModel);
        } catch (Exception e) {
            return ResponseEntity.status(NOT_FOUND).build();
        }
    }
}
