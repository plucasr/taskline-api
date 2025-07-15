require "test_helper"

class PresenceChannelTest < ActionCable::Channel::TestCase
  setup do
    @user = User.create!(email: "presence@user.dev", password: "secret123", password_confirmation: "secret123")
    @board = Board.create!(name: "Presence Board")
    @user.board_memberships.create!(board: @board, role: :owner)
  end

  test "subscribes and broadcasts join" do
    stub_connection current_user: @user

    subscribe board_id: @board.id

    assert subscription.confirmed?
    assert_broadcasts("board_#{@board.id}_presence", 1) do
      perform :subscribed
    end
  end

  test "rejects for non-members" do
    other = User.create!(email: "outsider@user.dev", password: "secret123", password_confirmation: "secret123")
    stub_connection current_user: other

    subscribe board_id: @board.id

    assert subscription.rejected?
  end
end
