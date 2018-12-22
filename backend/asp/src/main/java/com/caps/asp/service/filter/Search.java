package com.caps.asp.service.filter;

import com.caps.asp.model.TbRoom;
import org.springframework.data.jpa.domain.Specification;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.ArrayList;
import java.util.List;

public class Search implements Specification<TbRoom> {

    private String[] search;

    public String[] getSearch() {
        return search;
    }

    public void setSearch(String[] search) {
        this.search = search;
    }

    @Override
    public Predicate toPredicate(Root<TbRoom> roomRoot, CriteriaQuery<?> criteriaQuery, CriteriaBuilder cb) {

        List<Predicate> address = new ArrayList<>();

        for (int i = 0; i < search.length; i++) {
            address.add(cb.like(roomRoot.get("address"), "%" + search[i].trim() + "%"));
        }

        return cb.and(
                cb.and(address.toArray(new Predicate[address.size()]))
        );
    }
}
