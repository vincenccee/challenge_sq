class CalculatePreviousData
  attr_accessor :beggining_date, :end_date

  def initialize
    self.end_date = Order.maximum(:purchased_at)
  end

  # CalculatePreviousData.new.call
  def call
    ActiveRecord::Base.transaction do
      date = Order.minimum(:purchased_at)
      while date <= end_date
        Merchant.all.each do |merchant|
          DisbursementCalculation.new(merchant).run(date)
        end

        # calculate minimum charge when it is the first day of the month
        if date.mday == 1
          Merchant.all.each do |merchant|
            MinimumMonthlyFeeCalculation.new(merchant).run(date - 1.day)
          end
        end

        date = date + 1.day
      end
    end
  end
end