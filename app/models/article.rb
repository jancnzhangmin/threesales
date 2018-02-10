class Article < ApplicationRecord
  belongs_to :seller
  has_many :comments
end
