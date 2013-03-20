require 'test_helper'

class UserTest < ActiveSupport::TestCase
	should have_many(:user_friendships)
	should have_many(:friends)

	test "a user should enter a first name"  do
		user = User.new
		assert !user.save
		assert !user.errors[:first_name].empty?		
	end

	test "a user should enter a last name"  do
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?		
	end

	test "a user should enter a profile name"  do
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?		
	end

	test "a user should have a unique profile name" do
		user = User.new
		user.profile_name = users(:sean).profile_name

		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a profile name without spaces" do
		user = User.new(first_name: 'Sean', last_name: 'Everett', email: 'seanmeverett@gmail.com')
    	user.password = user.password_confirmation = 'asdfasdf'
		user.profile_name = "My Profile With Spaces"

		assert !user.save
		assert !user.errors[:profile_name].empty?
		assert user.errors[:profile_name].include?("must be formatted correctly.")
	end

	test "a user can have a correctly formatted profile name" do
    	user = User.new(first_name: 'Sean', last_name: 'Everett', email: 'seanmeverett@gmail.com')
    	user.password = user.password_confirmation = 'asdfasdf'

    	user.profile_name = 'seanmeverett_1'
    	assert user.valid?
  	end

  	test "that no error is raised when trying to access a friend list" do
  		assert_nothing_raised do
  			users(:sean).friends
  		end
  	end

  	test "that creating frienships on a user works" do
  		users(:sean).friends << users(:mike)
  		users(:sean).friends.reload
  		assert users(:sean).friends.include?(users(:mike))
  	end
end