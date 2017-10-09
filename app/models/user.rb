class User < ApplicationRecord

  has_many :sellerusers
  has_many :recepitaddre

  has_one :userpwd
end
