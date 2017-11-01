class Notice < ApplicationRecord

  belongs_to :seller

  has_attached_file :noticeimg, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :noticeimg

end
