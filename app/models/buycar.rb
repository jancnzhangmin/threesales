class Buycar < ApplicationRecord
  belongs_to :selleruser
  has_many :orders

  has_many :logisticorders
  has_many :buycarsigns

end
