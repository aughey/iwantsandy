class Renametable < ActiveRecord::Migration
  def self.up
    rename_table :sent_mails,:sent_emails
  end

  def self.down
  end
end
