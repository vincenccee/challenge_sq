class MinimumMonthlyFeeCalculation
  attr_accessor :merchant

  def initialize(merchant)
    self.merchant = merchant
  end

  def run(date)
    return if merchant.minimum_monthly_charges.where(year: date.year, month: date.month).present?
    return if merchant.minimum_monthly_fee == 0.0

    disbursements = disbursements_of_month(date)
    total_fee = disbursements.sum(:fee)

    if total_fee < merchant.minimum_monthly_fee
      amount = merchant.minimum_monthly_fee - total_fee
      merchant.minimum_monthly_charges.create(amount: amount, year: date.year, month: date.month)
    end
  end

  private

  def disbursements_of_month(date)
    return merchant.disbursements.where(disbursement_date: date.beginning_of_month..date.end_of_month)
  end
end