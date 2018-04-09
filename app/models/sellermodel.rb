class Sellermodel < ApplicationRecord
  belongs_to :seller
  has_many :modelconts ,dependent: :destroy
end
