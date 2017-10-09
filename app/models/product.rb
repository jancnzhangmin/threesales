class Product < ApplicationRecord
  belongs_to :productcla
  belongs_to :seller
  belongs_to :order
end
