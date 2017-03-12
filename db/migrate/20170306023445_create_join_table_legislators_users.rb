class CreateJoinTableLegislatorsUsers < ActiveRecord::Migration
  def change
    create_join_table :legislators, :users do |t|
      t.index [:legislator_id, :user_id]
    end
  end
end
