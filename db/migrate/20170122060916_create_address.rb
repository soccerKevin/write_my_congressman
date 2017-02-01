class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :legislator
      t.string :line
      t.string :city
      t.string :state
      t.string :zip
    end
  end
end
