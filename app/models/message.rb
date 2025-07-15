class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :body, presence: true

  def as_json(options = {})
    super(options.merge(include: { user: { only: %i[id email] } }))
  end
end
