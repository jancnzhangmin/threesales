class AddAttachmentNoticeimgToNotices < ActiveRecord::Migration
  def self.up
    change_table :notices do |t|
      t.attachment :noticeimg
    end
  end

  def self.down
    remove_attachment :notices, :noticeimg
  end
end
