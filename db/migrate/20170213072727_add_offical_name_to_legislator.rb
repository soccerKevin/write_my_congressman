class AddOfficalNameToLegislator < ActiveRecord::Migration
  def change
    add_column :legislators, :official_name, :string
  end
end
