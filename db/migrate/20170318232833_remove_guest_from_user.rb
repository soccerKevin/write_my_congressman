class RemoveGuestFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :guest, :boolean
  end
end
