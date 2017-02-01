class CreatePhone < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.references :legislator
      t.string :number
    end
  end
end
