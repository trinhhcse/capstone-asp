package com.caps.asp;

import com.caps.asp.model.TbPost;
import com.caps.asp.model.uimodel.request.FilterRequestModel;
import com.caps.asp.service.PostService;
import com.caps.asp.service.filter.Filter;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.ArrayList;
import java.util.List;

@RunWith(SpringRunner.class)
@SpringBootTest
public class AspApplicationTests {

	@Autowired
	private PostService postService;

	@Test
	public void contextLoads() {
		List<Integer> usernameList = new ArrayList<>();
		usernameList.add(10);
		usernameList.add(14);

		//List role
		List<Integer> roleList = new ArrayList<>();
		roleList.add(1);
		roleList.add(10);
		roleList.add(14);

		FilterRequestModel search=new FilterRequestModel();
		search.setDistricts(usernameList);
		search.setUtilities(roleList);
//		search.setGender(2);
//		search.setMaxPrice(100000);
//		search.setMinPrice(0);

		Filter filter = new Filter();
		filter.setFilterArgumentModel(null);

		List<TbPost> userList = postService.search(filter);
		System.out.println(userList);
	}

}
