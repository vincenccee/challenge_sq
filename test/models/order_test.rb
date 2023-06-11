require "test_helper"

class OrderTest < ActiveSupport::TestCase
  describe 'validation' do
    let(:merchant) { merchants(:treutel_schumm_fadel) }
    let(:amount) { 108.54 }
    let(:purchased_at) { Date.new(2023, 1, 1) }

    it 'should be valid' do
      order = Order.new(
        merchant: merchant,
        amount: amount,
        purchased_at: purchased_at
      )
      assert order.valid?
    end

    it 'should not be valid' do
      order = Order.new
      refute order.valid?
      assert_equal order.errors.full_messages,
        ["Merchant must exist", "Amount can't be blank", "Purchased at can't be blank"]
    end
  end
end
