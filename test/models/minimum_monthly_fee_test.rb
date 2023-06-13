require "test_helper"

class MinimumMonthlyFeeTest < ActiveSupport::TestCase
  describe 'validation' do
    let(:merchant) { merchants(:treutel_schumm_fadel) }
    let(:amount) { 108.54 }
    let(:year) { 2023 }
    let(:month) { 1 }

    it 'should be valid' do
      minimum_monthly_fee = MinimumMonthlyFee.new(
        merchant: merchant,
        amount: amount,
        year: year,
        month: month
      )
      assert minimum_monthly_fee.valid?
    end

    it 'should not be valid' do
      order = MinimumMonthlyFee.new
      refute order.valid?
      assert_equal order.errors.full_messages,
        ["Merchant must exist", "Amount can't be blank", "Year can't be blank", "Month can't be blank"]
    end
  end
end
