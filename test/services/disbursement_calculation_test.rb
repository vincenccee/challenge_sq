require "test_helper"

class DisbursementCalculationTest < ActiveSupport::TestCase
  describe 'run' do
    let(:date) { Date.new(2023, 1, 1) }
    let(:merchant) {
      Fabricate(:merchant,
        live_on: date,
        disbursement_frequency: :daily,
        minimum_monthly_fee: 29.0
      )
    }
    let(:service) { DisbursementCalculation.new(merchant) }

    it 'should not create disbursement when there is no order' do
      assert_difference 'Disbursement.count', 0 do
        service.run(date)
      end
    end

    it 'should create the disbursement when there is order' do
      Fabricate(:order, merchant: merchant, amount: 300, purchased_at: date)
      assert_difference 'Disbursement.count', 1 do
        service.run(date)
      end
    end

    it 'should apply the fee of 1% when the order amount is less than 50 euros' do
      Fabricate(:order, merchant: merchant, amount: 40, purchased_at: date)

      service.run(date)
      disbursement = merchant.disbursements.take

      assert_equal 39.6, disbursement.amount
      assert_equal 0.4, disbursement.fee
    end

    it 'should apply the fee of 0.95% when the order amount is between 50 and 300 euros' do
      Fabricate(:order, merchant: merchant, amount: 200, purchased_at: date)

      service.run(date)
      disbursement = merchant.disbursements.take

      assert_equal 198.10, disbursement.amount
      assert_equal 1.90, disbursement.fee
    end

    it 'should apply the fee of 0.85% when the order amount is more than 300 euros' do
      Fabricate(:order, merchant: merchant, amount: 500, purchased_at: date)

      service.run(date)
      disbursement = merchant.disbursements.take

      assert_equal 495.75, disbursement.amount
      assert_equal 4.25, disbursement.fee
    end

    it 'should update the orders used for the disbursement' do
      order = Fabricate(:order, merchant: merchant, amount: 500, purchased_at: date)

      assert order.disbursement.nil?

      service.run(date)
      disbursement = merchant.disbursements.take

      assert order.reload.disbursement.present?
      assert_equal disbursement, order.disbursement
    end

    describe 'merchant with disbursement frequency daily' do
      it 'should add up the amount and fee from all orders of that day' do
        Fabricate(:order, merchant: merchant, amount: 500, purchased_at: date)
        Fabricate(:order, merchant: merchant, amount: 200, purchased_at: date)

        service.run(date)
        disbursement = merchant.disbursements.take

        assert_equal 693.85, disbursement.amount
        assert_equal 6.15, disbursement.fee
      end
    end

    describe 'merchant with disbursement frequency weekly' do
      before do
        merchant.update_attribute(:disbursement_frequency, :weekly)
      end

      it 'should not create disbursement when it not the right day of the week' do
        Fabricate(:order, merchant: merchant, amount: 500, purchased_at: date + 1.day)

        assert_difference 'Disbursement.count', 0 do
          service.run(Date.new(2023, 1, 2))
        end
      end

      it 'should add up the amount and fee from all orders the week' do
        Fabricate(:order, merchant: merchant, amount: 500, purchased_at: date + 3.days)
        Fabricate(:order, merchant: merchant, amount: 200, purchased_at: date + 4.days)

        service.run(date + 7.days)
        disbursement = merchant.disbursements.take

        assert_equal 693.85, disbursement.amount
        assert_equal 6.15, disbursement.fee
      end

      it 'should not include orders from other weeks' do
        Fabricate(:order, merchant: merchant, amount: 500, purchased_at: date + 3.days)
        Fabricate(:order, merchant: merchant, amount: 200, purchased_at: date + 10.days)

        service.run(date + 14.days)
        disbursement = merchant.disbursements.take

        assert_equal 198.10, disbursement.amount
        assert_equal 1.90, disbursement.fee
      end
    end
  end
end
