class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :note

  belongs_to :parent, :class_name => "Comment", :foreign_key => :parent_id
  has_many :child_comments, :class_name => "Comment", :foreign_key => :parent_id
end
