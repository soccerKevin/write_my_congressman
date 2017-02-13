class AddOfficalNameToLegislator < ActiveRecord::Migration
  def change
    add_column :legislators, :official_name, :string
    add_column :legislators, :wikipedia, :string
  end
end
