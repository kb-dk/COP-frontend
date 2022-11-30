class CasUsers < ActiveRecord::Migration[5.0]
  def self.up
    add_column :users, :username, :string
    add_index :users, :username, :unique => true
  end

  def self.down
    remove_column :users, :username, :string
    remove_index :users, :username rescue nil
  end
end
