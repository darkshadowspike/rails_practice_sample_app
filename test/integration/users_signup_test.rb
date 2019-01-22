require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
   
   def setup
    ActionMailer::Base.deliveries.clear
   end

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

	test "succesfull  signup information with account activation" do
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
	   assert_equal 1, ActionMailer::Base.deliveries.size
	   user = assigns (:user)
	   assert_not user.activated?
       #try to log in before activation
	   log_in_as(user)
	   assert_not is_logged_in?
	   # Invalid activarion token
	   get edit_account_activation_path("invalid token", email: user.email)
	   assert_not is_logged_in?
	   #valid token, wrong email
	   get edit_account_activation_path(user.activation_token, email: "wrong")
	   assert_not is_logged_in?
	   #valid activation token
	   get edit_account_activation_path(user.activation_token, email: user.email)
	   assert user.reload.activated?
	   follow_redirect!
	   assert_template "users/show"
	   assert is_logged_in?
	end



end
