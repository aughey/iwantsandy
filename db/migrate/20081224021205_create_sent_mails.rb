class CreateSentMails < ActiveRecord::Migration
  def self.up
    create_table :sent_mails do |t|
      t.integer :parent_id
      t.string :parent_type
      t.text :rfc882
      t.timestamps
    end
  end

  def self.down
    drop_table :sent_mails
  end
end
