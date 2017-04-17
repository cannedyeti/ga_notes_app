class Note < ApplicationRecord
  belongs_to :user
  belongs_to :course
  has_many :comments
  has_and_belongs_to_many :tags, inverse_of: :note
end
