class CreateParseProblems < ActiveRecord::Migration
  def self.up
    create_table :parse_problems do |t|
      t.string :message
      t.integer :raw_email_id
      t.timestamps
    end
  end

  def self.down
    drop_table :parse_problems
  end
end
