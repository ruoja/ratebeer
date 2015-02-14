class ChangeBeers < ActiveRecord::Migration
  def change
  	change_table :beers do |b|
  		b.rename :style, :old_style
  	end
  	
  	beers = Beer.all
  	styles = Style.all
  	beers.each do |b|
  		bs = b.old_style
  		styles.each do |s|
  			if bs.eql?(s.name)
  				b.styles << s
  			end
  		end
  	end
  end

end
