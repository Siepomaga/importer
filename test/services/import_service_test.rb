require "test_helper"

class ImportServiceTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  def setup
    File.write("tmp/data.csv", <<~CSV)
      email,amount,channel,anonymous
      user1@example.com,100,credit_card,false
      user1@example.com,200,paypal,false
      user2@example.com,300,credit_card,true
    CSV
  end

  def teardown
    File.delete("tmp/data.csv") if File.exist?("tmp/data.csv")
    Payment.delete_all
    User.delete_all
  end

  test "should import users and payments from CSV" do
    assert_difference("User.count", 2) do
      assert_difference("Payment.count", 3) do
        ImportService.call
        ActiveRecord::Base.connection.clear_query_cache
      end
    end

    user1 = User.find_by(email: "user1@example.com")
    assert user1
    assert_equal 2, user1.payments.count

    assert_equal 100, user1.payments.first.amount
    assert_equal "credit_card", user1.payments.first.channel
    assert_not user1.payments.first.anonymous

    assert_equal 200, user1.payments.second.amount
    assert_equal "paypal", user1.payments.second.channel
    assert_not user1.payments.second.anonymous

    user2 = User.find_by(email: "user2@example.com")
    assert user2
    assert_equal 1, user2.payments.count

    assert_equal 300, user2.payments.first.amount
    assert_equal "credit_card", user2.payments.first.channel
    assert user2.payments.first.anonymous
  end
end
