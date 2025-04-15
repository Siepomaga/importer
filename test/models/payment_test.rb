require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  test "should validate presence of amount" do
    payment = Payment.new(channel: "credit_card")
    assert_not payment.valid?
    assert_includes payment.errors[:amount], "can't be blank"
  end

  test "should validate numericality of amount" do
    payment = Payment.new(amount: -10, channel: "credit_card")
    assert_not payment.valid?
    assert_includes payment.errors[:amount], "must be greater than 0"
  end

  test "should validate presence of channel" do
    payment = Payment.new(amount: 100)
    assert_not payment.valid?
    assert_includes payment.errors[:channel], "can't be blank"
  end

  test "should belong to user" do
    user = User.create!(email: "test@example.com")
    payment = Payment.new(amount: 100, channel: "credit_card", user: user)
    assert payment.valid?
    assert_equal user, payment.user
  end

  test "should have correct columns" do
    columns = Payment.column_names
    assert_includes columns, "id"
    assert_includes columns, "amount"
    assert_includes columns, "channel"
    assert_includes columns, "user_id"
    assert_includes columns, "created_at"
    assert_includes columns, "updated_at"
  end
end
