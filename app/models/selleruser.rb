class Selleruser < ApplicationRecord
  belongs_to :seller
  has_many :buycars
end
