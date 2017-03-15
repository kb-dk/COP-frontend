class CasUsername < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :fullname
    end
  end
end
