require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
  @user = User.new(name: "Example User", email:"USER@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
   assert @user.valid?
  end 

  test "name should be present" do
  	@user.name="   "
  	assert_not @user.valid?
  end

  test "email should be present" do
  @user.email="   "
  assert_not @user.valid?
  end

  test "name should not be too long" do
   @user.name = "a" * 51
   assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.name = "a"* 244 +"@example.com"
  	assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
   
	   valid_addresses = ["user.@example.com", "USER@foo.COM", "A_US-ER@foo.bar.org", "first.last@foo.jp", "alice+bob@baz.cn"]
	   
	   valid_addresses.each do |valid_address|
	    @user.email = valid_address
	    assert @user.valid?, "#{valid_address.inspect} should be valid"
	   end 
   end

   test "email validation should reject invalid addresses" do
	    invalid_addresses = ["user@example,com", "user_at_foo.org", "user.name@example.", "foo@bar_baz.com", "foo@bar+baz.com", "foo@bar..com"]
	    
	    invalid_addresses.each do |invalid_address|
		      @user.email = invalid_address
		      assert_not @user.valid?, "#{invalid_address.inspect} shold be invalid"
	    end

	end 

	test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email= @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
	end

	test "email should be in lowercase" do
	@user.save
	lowcaseuser = @user.reload
	assert_equal lowcaseuser.email, "user@example.com"
	end
    
    test "password should be present (nonblank)" do
    	@user.password = @user.password_confirmation = " " * 6
    	assert_not @user.valid?
    end

    test "password should have a minimum length" do
    	@user.password = @user.password_confirmation = "a"* 5
    	assert_not @user.valid?
    end
  
  test "authenticated? should return false for a user with nil digest" do
   assert_not @user.authenticated?(:remember,"")
  end
  
  test "associated micrposts should be destroyed" do
   @user.save 
   @user.microposts.create!(content:"Lorem ipsum")
   assert_difference "Micropost.count", -1 do
       @user.destroy 
   end 
  end
   
   test "should follow and unfollow a user" do 
    andrew = users(:Andrew)
    archer = users(:Archer)
    assert_not andrew.following?(archer)
    andrew.follow(archer)
    assert archer.followers.include?(andrew)
    assert andrew.following?(archer)
    andrew.unfollow(archer)
    assert_not  andrew.following?(archer)
   end

   test "feed should have the right posts" do
     andrew = users(:Andrew)
     archer = users(:Archer)
     lana = users(:lana) 

     lana.microposts.each do |post_following|
        assert andrew.feed.include?(post_following) 
     end 

     andrew.microposts.each do |post_self|
        assert andrew.feed.include?(post_self)
     end

     archer.microposts.each do |post__unfollowed|
       assert_not andrew.feed.include?(post__unfollowed)
     end 

   end
end
