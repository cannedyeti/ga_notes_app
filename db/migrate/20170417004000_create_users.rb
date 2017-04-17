class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :photo
      t.integer :points
      t.integer :privilege
      t.text :favorites, array: true, default: []
      t.integer :default_course_id
      t.integer :location_id

      t.timestamps
    end
  end
end
