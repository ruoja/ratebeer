class AddStyleRefToBeers < ActiveRecord::Migration
  def change
    add_reference :beers, :style, index: true
    add_foreign_key :beers, :styles
    styles = ["Weizen", "Lager", "Pale ale", "IPA", "Porter"]
    styles.each{ |s| Style.create name:s, description:"" }
  end
end
