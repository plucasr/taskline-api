class Card < ApplicationRecord
  belongs_to :column

  validates :title, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
