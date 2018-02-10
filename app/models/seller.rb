class Seller < ApplicationRecord
  has_many :productclas

  has_many :sellerusers
  has_many :buycars

  has_many :products
  has_many :admins

  has_many :notices

  has_many :weixinmenus

  has_many :articles

  has_attached_file :sellerimage, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :sellerimage

  has_attached_file :qrcode, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :qrcode
end
