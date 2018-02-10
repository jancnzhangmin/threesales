class Selleruser < ApplicationRecord
  belongs_to :seller
  belongs_to :user
  belongs_to :retoforder

  has_many :buycars
  has_many :systemlogs
end
