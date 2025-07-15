require "test_helper"

class RoomChannelTest < ActionCable::Channel::TestCase
  setup do
    @user = User.create!(email: "room@user.dev", password: "secret123", password_confirmation: "secret123")
    @board = Board.create!(name: "Room Board")
    @user.board_memberships.create!(board: @board, role: :owner)
    @room = @board.rooms.create!(name: "General")
  end

  test "speak persists and broadcasts the message" do
    stub_connection current_user: @user
    subscribe board_id: @board.id, room_id: @room.id
    assert subscription.confirmed?

    assert_broadcasts("room_#{@room.id}", 1) do
      perform :speak, body: "hello"
    end

    message = @room.messages.last
    assert_equal "hello", message.body
    assert_equal @user.id, message.user_id
  end

  test "rejects non-members" do
    other = User.create!(email: "room-outsider@user.dev", password: "secret123", password_confirmation: "secret123")
    stub_connection current_user: other

    subscribe board_id: @board.id, room_id: @room.id

    assert subscription.rejected?
  end
end
