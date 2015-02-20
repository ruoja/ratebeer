class AddDefaultValueToActiveAttribute < ActiveRecord::Migration
  def up
    change_column :breweries, :active, :boolean, :default => true
  end

  def down
    change_column :breweries, :active, :boolean, :default => nil
  end
end
