class MinimumMonthlyFee < ApplicationRecord
  belongs_to :merchant, inverse_of: :minimum_monthly_fees

  validates :amount, presence: true
  validates :year, presence: true
  validates :month, presence: true
end
