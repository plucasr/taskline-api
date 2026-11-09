class User < ApplicationRecord
  has_secure_password

  has_many :board_memberships, dependent: :destroy
  has_many :boards, through: :board_memberships

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def owner_of?(board)
    board_memberships.exists?(board: board, role: :owner)
  end

  def member_of?(board)
    board_memberships.exists?(board: board)
  end
end
