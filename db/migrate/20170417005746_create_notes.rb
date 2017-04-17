class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.text :up_votes, array:true, default: []
      t.text :down_votes, array:true, default: [] 
      t.text :whitelist, array:true, default: []
      t.text :image_urls, array:true, default: []
      t.references :user, foreign_key: true
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
