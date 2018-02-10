class AddAttachmentQrcodeToSellers < ActiveRecord::Migration
  def self.up
    change_table :sellers do |t|
      t.attachment :qrcode
    end
  end

  def self.down
    remove_attachment :sellers, :qrcode
  end
end
