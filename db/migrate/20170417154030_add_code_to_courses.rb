class AddCodeToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :code, :string
  end
end
