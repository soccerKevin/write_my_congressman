class CreateLegislator < ActiveRecord::Migration
  def change
    create_table :legislators do |t|
      t.string :bio_id
      t.string :first_name
      t.string :last_name
      t.index :last_name
      t.date :birthday
      t.string :gender
      t.string :religion
      t.string :position
      t.string :party
      t.date :started
      t.string :state
      t.string :district
      t.string :url
      t.references :address
      t.references :phone
      t.references :fax
      t.string :contact_form_url
      t.string :twitter_name
      t.string :facebook_name
      t.string :facebook_id
      t.string :youtube_id
      t.string :twitter_id
    end
  end
end
