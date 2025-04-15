require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without email" do
    user = User.new
    assert_not user.save, "Saved the user without an email"
  end

  test "should not save user with duplicate email" do
    user1 = User.create(email: "test@example.com")
    user2 = User.new(email: "test@example.com")
    assert_not user2.save, "Saved the user with a duplicate email"
  end

  test "should have email column" do
    assert User.column_names.include?("email"), "User model does not have an email column"
  end

  test "should have payments association" do
    assert_respond_to User.new, :payments, "User model does not have a payments association"
  end
end
