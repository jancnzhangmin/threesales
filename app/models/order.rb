class Order < ApplicationRecord

  belongs_to :buycar

  has_many :products
end
