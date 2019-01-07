require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
   test "invalid signup information" do
	   get signup_path
	   assert_no_difference "User.count" do
		   	post users_path, params:{
		   		user:{
		   			name:"",
		   			email: "user@invalid",
		   			password: "foo",
		   			password_confirmation: "Bar"
		   		}
		   	}
	
	   end
	assert_template "users/new" 
	assert_select "div#error_explanation" 
	assert_select "div.has-error"
	end

	test "succesfull  signup information" do
	   get signup_path
	   assert_difference "User.count", 1 do
	   	     post users_path, params:{
		   		user:{
		   			name:"pepeb312",
		   			email: "pepito@valid.com",
		   			password: "validb1",
		   			password_confirmation: "validb1"
		   		}
		   	}
	   end
	   follow_redirect!
	   assert_template "users/show"
	   assert_not flash.empty?
	end

end
