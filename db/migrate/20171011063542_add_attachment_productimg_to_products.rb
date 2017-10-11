class AddAttachmentProductimgToProducts < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.attachment :productimg
    end
  end

  def self.down
    remove_attachment :products, :productimg
  end
end
