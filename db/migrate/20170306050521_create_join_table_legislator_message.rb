class CreateJoinTableLegislatorMessage < ActiveRecord::Migration
  def change
    create_join_table :legislators, :messages do |t|
      t.index [:legislator_id, :message_id]
    end
  end
end
