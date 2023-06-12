class DisbursementCalculation
  attr_accessor :merchant

  def initialize(merchant)
    self.merchant = merchant
  end

  def run(date)
    orders = orders_within_date(date)

    return if orders.blank?

    disbursement = merchant.disbursements.new(amount: 0.0, fee: 0.0, disbursement_date: date)
    orders.each do |order|
      fee = calculate_fee(order.amount)
      amount = order.amount - fee

      disbursement.fee += fee
      disbursement.amount += amount
    end

    if disbursement.valid?
      disbursement.save

      orders.update_all(disbursement_id: disbursement.id)
    end
  end

  private

  def orders_within_date(date)
    if merchant.daily?
      orders_daily(date)
    elsif merchant.week_day == date.wday
      orders_weekly(date)
    else
      []
    end
  end

  def orders_daily(date)
    merchant.orders.where(purchased_at: date)
  end

  def orders_weekly(date)
    one_week_ago = date - 6.days
    merchant.orders.where(purchased_at: one_week_ago..date)
  end

  def calculate_fee(amount)
    if amount < 50.00
      amount * 0.01
    elsif amount >= 50.00 && amount < 300.00
      amount * 0.0095
    else
      amount * 0.0085
    end
  end
end