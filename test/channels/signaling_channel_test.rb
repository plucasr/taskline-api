require "test_helper"

class SignalingChannelTest < ActionCable::Channel::TestCase
  setup do
    @user = User.create!(email: "signal@user.dev", password: "secret123", password_confirmation: "secret123")
    @board = Board.create!(name: "Signal Board")
    @user.board_memberships.create!(board: @board, role: :owner)
    @room = @board.rooms.create!(name: "Voice")
  end

  test "relays signaling payloads" do
    stub_connection current_user: @user
    subscribe board_id: @board.id, room_id: @room.id

    assert_broadcasts("room_#{@room.id}_signaling", 1) do
      perform :signal, type: "offer", payload: { sdp: "..." }
    end
  end

  test "rejects non-members" do
    other = User.create!(email: "signal-outsider@user.dev", password: "secret123", password_confirmation: "secret123")
    stub_connection current_user: other

    subscribe board_id: @board.id, room_id: @room.id

    assert subscription.rejected?
  end
end
