class Board < ApplicationRecord
  has_many :board_memberships, dependent: :destroy
  has_many :members, through: :board_memberships, source: :user
  has_many :columns, -> { order(:position) }, dependent: :destroy
  has_many :cards, through: :columns
  has_many :rooms, dependent: :destroy

  validates :name, presence: true

  def owner
    memberships = board_memberships.select { |m| m.owner? }
    memberships.first&.user
  end
end
