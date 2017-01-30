class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line
      t.string :city
      t.string :state
      t.string :zip
    end
  end
end
