class User < ApplicationRecord

  has_many :sellerusers
  has_many :recepitaddres

  has_one :userpwd
end
