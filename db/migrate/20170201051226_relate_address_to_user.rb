class RelateAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    add_reference :addresses, :user, index: true
  end
end
