require "test_helper"

class MerchantTest < ActiveSupport::TestCase
  describe 'validation' do
    let(:title) { 'title test' }
    let(:email) { 'test@test.com' }
    let(:live_on) { Date.new(2023, 1, 1) }
    let(:disbursement_frequency) { :daily }
    let(:minimum_monthly_fee) { 29.0 }

    it 'should be valid' do
      merchant = Merchant.new(
        title: title,
        email: email,
        live_on: live_on,
        disbursement_frequency: disbursement_frequency,
        minimum_monthly_fee: minimum_monthly_fee
      )
      assert merchant.valid?
    end

    it 'should not be valid' do
      merchant = Merchant.new
      refute merchant.valid?
      assert_equal merchant.errors.full_messages,
        ["Title can't be blank", "Email can't be blank", "Live on can't be blank"]
    end
  end

  describe 'week day for live on date' do
    let(:merchant) { merchants(:treutel_schumm_fadel) }

    it 'should return the number of the day of the week' do
      assert_equal merchant.week_day, 0
    end
  end
end
