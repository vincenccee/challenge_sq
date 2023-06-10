class Merchant < ApplicationRecord
  validates :title, presence: true
  validates :email, presence: true
  validates :live_on, presence: true
  validates :disbursement_frequency, presence: true
  validates :minimum_monthly_fee, presence: true

  enum disbursement_frequency: %i(daily weekly)

  def week_day
    self.live_on.wday
  end
end
