class Buycar < ApplicationRecord
  belongs_to :selleruser
  has_many :orders

  has_many :logisticorders

end
