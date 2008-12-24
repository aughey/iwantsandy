class Rename882 < ActiveRecord::Migration
  def self.up
    rename_column :sent_emails,:rfc882,:rfc822
  end

  def self.down
  end
end
