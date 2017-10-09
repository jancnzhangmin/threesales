class Buycar < ApplicationRecord
  belongs_to :selleruser
  has_many :orders

end
