class AddDefaultValueToBannedAttribute < ActiveRecord::Migration
  def up
    change_column :users, :banned, :boolean, :default => false
  end

  def down
    change_column :users, :banned, :boolean, :default => nil
  end
end
