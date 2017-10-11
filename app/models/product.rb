class Product < ApplicationRecord
  belongs_to :productcla
  belongs_to :seller
  belongs_to :order
  has_attached_file :productimg, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :productimg
end
