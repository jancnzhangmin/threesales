class Selleruser < ApplicationRecord
  belongs_to :seller
  belongs_to :user

  has_many :buycars
end
