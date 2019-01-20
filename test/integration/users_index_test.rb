require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

	  def setup
	  @user = users(:Andrew)
	  @other_user = users(:Archer)
	  end

	  test "index including pagination " do
	  	 log_in_as(@user , password: 'pepeb312', remember_me: '0')	  	 	  	
	  	 get users_path
	  	 assert_template 'users/index'
	  	 assert_select 'div.pagination'
	  	 User.paginate(page: 1).each do |user|
             assert_select 'a[href=?]', user_path(user), text: user.name
             unless user == @user
               assert_select "a[href =?]", user_path(user), text: "delete"
             end
	  	 end
	  	 assert_difference "User.count", -1 do
           delete user_path(@other_user)
	  	 end
	  end

	  test "index as a non-admin" do
        log_in_as(@other_user , password: 'password', remember_me: '0')
        get users_path
        assert_select "a", text: "delete", count: 0
	  end	
end
