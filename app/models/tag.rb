class Tag < ApplicationRecord
  has_and_belongs_to_many :notes,  inverse_of: :tag
end
