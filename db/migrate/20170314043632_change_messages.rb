class ChangeMessages < ActiveRecord::Migration
  def change
    add_column    :messages, :name,         :string
    add_column    :messages, :email,        :string
    add_column    :messages, :address_line, :string
    add_column    :messages, :city,         :string
    add_column    :messages, :state,        :string
    add_column    :messages, :zip,          :string
  end
end
