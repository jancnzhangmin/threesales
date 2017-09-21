class AddAttachmentSellerimageToSellers < ActiveRecord::Migration
  def self.up
    change_table :sellers do |t|
      t.attachment :sellerimage
    end
  end

  def self.down
    remove_attachment :sellers, :sellerimage
  end
end
