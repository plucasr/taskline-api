class BoardMembership < ApplicationRecord
  belongs_to :user
  belongs_to :board

  enum :role, { member: 0, owner: 1 }

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :board_id }
end
