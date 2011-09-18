class CreateRunes < ActiveRecord::Migration
  def change
    create_table :runes do |t|
      t.string :name
      t.string :img_url
      t.string :slug, :unique => true
      t.timestamps
    end
  end
end
