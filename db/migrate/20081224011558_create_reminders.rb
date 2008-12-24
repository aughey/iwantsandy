class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.datetime :time
      t.string :message
      t.timestamps
    end
  end

  def self.down
    drop_table :reminders
  end
end
