class Room < ApplicationRecord
  belongs_to :board
  has_many :messages, -> { order(:created_at) }, dependent: :destroy

  validates :name, presence: true
end
