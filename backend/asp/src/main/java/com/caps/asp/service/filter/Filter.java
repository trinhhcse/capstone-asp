package com.caps.asp.service.filter;

import com.caps.asp.model.*;
import com.caps.asp.model.uimodel.request.FilterArgumentModel;
import org.springframework.data.jpa.domain.Specification;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.ArrayList;
import java.util.List;

import static com.caps.asp.constant.Constant.*;

public class Filter implements Specification<TbPost> {

    private FilterArgumentModel filterArgumentModel;

    public FilterArgumentModel getFilterArgumentModel() {
        return filterArgumentModel;
    }

    public void setFilterArgumentModel(FilterArgumentModel filterArgumentModel) {
        this.filterArgumentModel = filterArgumentModel;
    }

    @Override
    public Predicate toPredicate(Root<TbPost> postRoot, CriteriaQuery<?> criteriaQuery, CriteriaBuilder cb) {
        if (filterArgumentModel.getFilterRequestModel() == null && filterArgumentModel.getTypeId() == null)
            return cb.conjunction();

        criteriaQuery.distinct(true);

        if (filterArgumentModel.getTypeId() == MASTER_POST) {

            if (filterArgumentModel.getFilterRequestModel() != null) {

                Root<TbRoom> roomRoot = criteriaQuery.from(TbRoom.class);
                Root<TbDistrict> districtRoot = criteriaQuery.from(TbDistrict.class);
                Root<TbRoomHasUtility> roomHasUtilityRoot = criteriaQuery.from(TbRoomHasUtility.class);
                Root<TbUtilities> utilitiesRoot = criteriaQuery.from(TbUtilities.class);

                List<Predicate> districtList = new ArrayList<>();
                List<Predicate> utilityList = new ArrayList<>();
                List<Predicate> priceList = new ArrayList<>();
                List<Predicate> genderList = new ArrayList<>();
                List<Predicate> typeList = new ArrayList<>();

                if (filterArgumentModel.getOrderBy() == NEWPOST) {
                    criteriaQuery.orderBy(cb.desc(postRoot.get("datePost")));
                } else if (filterArgumentModel.getOrderBy() == PRICEDESC) {
                    criteriaQuery.orderBy(cb.asc(postRoot.get("minPrice")));
                } else if (filterArgumentModel.getOrderBy() == PRICEASC) {
                    criteriaQuery.orderBy(cb.desc(postRoot.get("minPrice")));
                }

                if (filterArgumentModel.getFilterRequestModel().getDistricts() != null) {
                    for (Integer districtId : filterArgumentModel.getFilterRequestModel().getDistricts()) {
                        districtList.add(cb.equal(districtRoot.get("districtId"), districtId));
                    }
                } else {
                    districtList.add(cb.conjunction());
                }

                if (filterArgumentModel.getFilterRequestModel().getUtilities() != null) {
                    for (Integer utilityId : filterArgumentModel.getFilterRequestModel().getUtilities()) {
                        utilityList.add(cb.equal(roomHasUtilityRoot.get("utilityId"), utilityId));
                    }
                } else {
                    utilityList.add(cb.conjunction());
                }

                if (filterArgumentModel.getFilterRequestModel().getGender() != null
                        && (filterArgumentModel.getFilterRequestModel().getGender() == FEMALE
                        || filterArgumentModel.getFilterRequestModel().getGender() == MALE)) {

                    genderList.add(cb.equal(postRoot.get("genderPartner"), filterArgumentModel.getFilterRequestModel().getGender()));
                } else {
                    genderList.add(cb.conjunction());
                }

                if (filterArgumentModel.getFilterRequestModel().getPrice() != null
                        && filterArgumentModel.getFilterRequestModel().getPrice().size() == 2) {
                    priceList.add(cb.and(
                            cb.ge(postRoot.get("minPrice"), filterArgumentModel.getFilterRequestModel().getPrice().get(0)),
                            cb.le(postRoot.get("minPrice"), filterArgumentModel.getFilterRequestModel().getPrice().get(1))));
                } else {
                    priceList.add(cb.conjunction());
                }

                if (filterArgumentModel.getTypeId() != null) {
                    typeList.add(cb.equal(postRoot.get("typeId"), filterArgumentModel.getTypeId()));
                } else {
                    typeList.add(cb.conjunction());
                }

                if (districtList.size() == 0) districtList.add(cb.conjunction());
                if (utilityList.size() == 0) utilityList.add(cb.conjunction());
                if (genderList.size() == 0) genderList.add(cb.conjunction());
                if (priceList.size() == 0) priceList.add(cb.conjunction());

                return cb.and(
                        cb.equal(postRoot.get("roomId"), roomRoot.get("roomId")),
                        cb.equal(roomRoot.get("districtId"), districtRoot.get("districtId")),
                        cb.equal(roomRoot.get("roomId"), roomHasUtilityRoot.get("roomId")),
                        cb.equal(roomHasUtilityRoot.get("utilityId"), utilitiesRoot.get("utilityId")),
                        cb.equal(districtRoot.get("cityId"), filterArgumentModel.getCityId()),

                        cb.notEqual(postRoot.get("userId"),filterArgumentModel.getUserId()),
                        cb.or(typeList.toArray(new Predicate[typeList.size()])),
                        cb.or(districtList.toArray(new Predicate[districtList.size()])),
                        cb.or(utilityList.toArray(new Predicate[utilityList.size()])),
                        cb.or(genderList.toArray(new Predicate[genderList.size()])),
                        cb.or(priceList.toArray(new Predicate[priceList.size()]))

                );
            } else {
                Root<TbDistrict> districtRoot = criteriaQuery.from(TbDistrict.class);
                Root<TbPostHasTbDistrict> postHasTbDistrictRoot = criteriaQuery.from(TbPostHasTbDistrict.class);
                if (filterArgumentModel.getOrderBy() == NEWPOST) {
                    criteriaQuery.orderBy(cb.desc(postRoot.get("datePost")));
                } else if (filterArgumentModel.getOrderBy() == PRICEDESC) {
                    criteriaQuery.orderBy(cb.asc(postRoot.get("minPrice")));
                } else if (filterArgumentModel.getOrderBy() == PRICEASC) {
                    criteriaQuery.orderBy(cb.desc(postRoot.get("minPrice")));
                }
                return cb.and(
                        cb.equal(postRoot.get("postId"),postHasTbDistrictRoot.get("postId")),
                        cb.equal(postHasTbDistrictRoot.get("districtId"), districtRoot.get("districtId")),
                        cb.equal(postRoot.get("typeId"), filterArgumentModel.getTypeId()),
                        cb.equal(districtRoot.get("cityId"), filterArgumentModel.getCityId())
                );
            }
        } else {
            if (filterArgumentModel.getFilterRequestModel() != null) {

                List<Predicate> districtList = new ArrayList<>();
                List<Predicate> utilityList = new ArrayList<>();
                List<Predicate> priceList = new ArrayList<>();
                List<Predicate> genderList = new ArrayList<>();
                List<Predicate> typeList = new ArrayList<>();
                List<Predicate> userList = new ArrayList<>();

                Root<TbUser> userRoot = criteriaQuery.from(TbUser.class);
                Root<TbPostHasUtility> utilitiesReferenceRoot = criteriaQuery.from(TbPostHasUtility.class);
                Root<TbUtilities> utilitiesRoot = criteriaQuery.from(TbUtilities.class);
                Root<TbPostHasTbDistrict> districtReferenceRoot = criteriaQuery.from(TbPostHasTbDistrict.class);
                Root<TbDistrict> districtRoot = criteriaQuery.from(TbDistrict.class);

                if (filterArgumentModel.getOrderBy() == NEWPOST) {
                    criteriaQuery.orderBy(cb.desc(postRoot.get("datePost")));
                } else if (filterArgumentModel.getOrderBy() == PRICEDESC) {
                    criteriaQuery.orderBy(cb.asc(postRoot.get("minPrice")));
                } else if (filterArgumentModel.getOrderBy() == PRICEASC) {
                    criteriaQuery.orderBy(cb.desc(postRoot.get("minPrice")));
                }

                if (filterArgumentModel.getFilterRequestModel().getDistricts() != null) {
                    for (Integer districtId : filterArgumentModel.getFilterRequestModel().getDistricts()) {
                        districtList.add(cb.equal(districtRoot.get("districtId"), districtId));
                    }
                } else {
                    districtList.add(cb.conjunction());
                }

                if (filterArgumentModel.getFilterRequestModel().getUtilities() != null) {
                    for (Integer utilityId : filterArgumentModel.getFilterRequestModel().getUtilities()) {
                        utilityList.add(cb.equal(utilitiesReferenceRoot.get("utilityId"), utilityId));
                    }
                } else {
                    utilityList.add(cb.conjunction());
                }

                if (filterArgumentModel.getFilterRequestModel().getGender() != null
                        &&(filterArgumentModel.getFilterRequestModel().getGender() == 1
                        || filterArgumentModel.getFilterRequestModel().getGender() == 2)) {

                    genderList.add(cb.equal(postRoot.get("genderPartner"), filterArgumentModel.getFilterRequestModel().getGender()));
                } else {
                    genderList.add(cb.conjunction());
                }

                if (filterArgumentModel.getFilterRequestModel().getPrice() != null
                        && filterArgumentModel.getFilterRequestModel().getPrice().size() == 2) {
                    priceList.add(cb.and(
                            cb.between(postRoot.get("minPrice")
                                    , filterArgumentModel.getFilterRequestModel().getPrice().get(0)
                                    , filterArgumentModel.getFilterRequestModel().getPrice().get(1))));
                }

                if (filterArgumentModel.getTypeId() != null) {
                    typeList.add(cb.equal(postRoot.get("typeId"), filterArgumentModel.getTypeId()));
                } else {
                    typeList.add(cb.conjunction());
                }

                if (filterArgumentModel.getUserId() != null) {
                    userList.add(cb.equal(userRoot.get("userId"), filterArgumentModel.getUserId()));
                } else {
                    userList.add(cb.conjunction());
                }

                if (districtList.size() == 0) districtList.add(cb.conjunction());
                if (utilityList.size() == 0) utilityList.add(cb.conjunction());
                if (genderList.size() == 0) genderList.add(cb.conjunction());
                if (priceList.size() == 0) priceList.add(cb.conjunction());

                return cb.and(
                        cb.equal(postRoot.get("postId"), utilitiesReferenceRoot.get("postId")),
                        cb.equal(utilitiesReferenceRoot.get("utilityId"), utilitiesRoot.get("utilityId")),
                        cb.equal(postRoot.get("postId"), districtReferenceRoot.get("postId")),
                        cb.equal(districtReferenceRoot.get("districtId"), districtRoot.get("districtId")),
                        cb.equal(districtRoot.get("cityId"), filterArgumentModel.getCityId()),

                        cb.or(typeList.toArray(new Predicate[typeList.size()])),
                        cb.or(districtList.toArray(new Predicate[districtList.size()])),
                        cb.or(utilityList.toArray(new Predicate[utilityList.size()])),
                        cb.or(genderList.toArray(new Predicate[genderList.size()])),
                        cb.or(priceList.toArray(new Predicate[priceList.size()]))
                );
            } else {
                Root<TbDistrict> districtRoot = criteriaQuery.from(TbDistrict.class);
                Root<TbPostHasTbDistrict> postHasTbDistrictRoot = criteriaQuery.from(TbPostHasTbDistrict.class);
                if (filterArgumentModel.getOrderBy() == NEWPOST) {
                    criteriaQuery.orderBy(cb.desc(postRoot.get("datePost")));
                } else if (filterArgumentModel.getOrderBy() == PRICEDESC) {
                    criteriaQuery.orderBy(cb.asc(postRoot.get("minPrice")));
                } else if (filterArgumentModel.getOrderBy() == PRICEASC) {
                    criteriaQuery.orderBy(cb.desc(postRoot.get("minPrice")));
                }
                return cb.and(
                        cb.equal(postRoot.get("postId"),postHasTbDistrictRoot.get("postId")),
                        cb.equal(postHasTbDistrictRoot.get("districtId"), districtRoot.get("districtId")),
                        cb.equal(postRoot.get("typeId"), filterArgumentModel.getTypeId()),
                        cb.equal(districtRoot.get("cityId"), filterArgumentModel.getCityId())
                );
            }
        }
    }
}
