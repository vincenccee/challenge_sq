class Order < ApplicationRecord
  belongs_to :merchant, inverse_of: :orders

  validates :amount, presence: true
  validates :purchased_at, presence: true
end
