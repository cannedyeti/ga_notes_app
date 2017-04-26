class AddIsOfficialCourseToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :is_official_course, :boolean, :default => true
  end
end
