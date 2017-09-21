class Seller < ApplicationRecord
  has_attached_file :sellerimage, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :sellerimage
end
