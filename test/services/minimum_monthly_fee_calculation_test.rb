require "test_helper"

class MinimumMonthlyFeeCalculationTest < ActiveSupport::TestCase
  describe 'run' do
    let(:date) { Date.new(2023, 1, 1) }
    let(:merchant) {
      Fabricate(:merchant,
        live_on: date,
        disbursement_frequency: :daily,
        minimum_monthly_fee: 0.0
      )
    }
    let(:service) { MinimumMonthlyFeeCalculation.new(merchant) }

    it 'should not create a minimum monthly charge when the minimum monthly fee is zero' do
      assert_difference 'MinimumMonthlyCharge.count', 0 do
        service.run(date)
      end
    end

    it 'should create a minimum monthly charge with full when there is no disbursement for that month' do
      merchant.update_attribute(:minimum_monthly_fee, 30.0)
      assert_difference 'MinimumMonthlyCharge.count', 1 do
        service.run(date)
      end

      monthly_charge = merchant.reload.minimum_monthly_charges.take
      assert_equal 30.0, monthly_charge.amount
    end

    it 'should sum all fees from the disbursement of the month and subtract from the minimun monthly fee' do
      merchant.update_attribute(:minimum_monthly_fee, 30.0)
      Fabricate(:disbursement, merchant: merchant, fee: 1, disbursement_date: date + 10.days)
      Fabricate(:disbursement, merchant: merchant, fee: 6, disbursement_date: date + 20.days)

      service.run(date)
      monthly_charge = merchant.reload.minimum_monthly_charges.take

      assert_equal 23.0, monthly_charge.amount
    end

    it 'should not create charge when the total fee is greater than the minium fee' do
      merchant.update_attribute(:minimum_monthly_fee, 10.0)
      Fabricate(:disbursement, merchant: merchant, fee: 8, disbursement_date: date + 10.days)
      Fabricate(:disbursement, merchant: merchant, fee: 6, disbursement_date: date + 20.days)

      assert_difference 'MinimumMonthlyCharge.count', 0 do
        service.run(date)
      end
    end
  end
end