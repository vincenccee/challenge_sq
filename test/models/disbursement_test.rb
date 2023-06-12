require "test_helper"

class DisbursementTest < ActiveSupport::TestCase
  describe 'validation' do
    let(:merchant) { merchants(:treutel_schumm_fadel) }
    let(:amount) { 108.54 }
    let(:fee) { 1.08 }
    let(:disbursement_date) { Date.new(2023, 1, 1) }

    it 'should be valid' do
      disbursement = Disbursement.new(
        merchant: merchant,
        amount: amount,
        fee: fee,
        disbursement_date: disbursement_date
      )
      assert disbursement.valid?
    end

    it 'should not be valid' do
      disbursement = Disbursement.new
      refute disbursement.valid?
      assert_equal disbursement.errors.full_messages,
        ["Merchant must exist", "Amount can't be blank", "Fee can't be blank", "Disbursement date can't be blank"]
    end
  end
end
