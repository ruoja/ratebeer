class ChangeBeers < ActiveRecord::Migration
  def change
  	change_table :beers do |b|
  		b.rename :style, :old_style
  	end
  end
end
