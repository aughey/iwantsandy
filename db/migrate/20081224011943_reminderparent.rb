class Reminderparent < ActiveRecord::Migration
  def self.up
    add_column :reminders,:raw_email_id,:integer
    add_index :reminders,:raw_email_id
    add_index :parse_problems,:raw_email_id
  end

  def self.down
  end
end
