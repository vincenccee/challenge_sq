class Disbursement < ApplicationRecord
  belongs_to :merchant, inverse_of: :disbursements
  has_many :orders, inverse_of: :disbursement

  validates :amount, presence: true
  validates :fee, presence: true
  validates :disbursement_date, presence: true
end
