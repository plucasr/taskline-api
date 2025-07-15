class RoomChannel < ApplicationCable::Channel
  def subscribed
    room = find_room
    return reject unless room

    stream_from "room_#{room.id}"
  end

  def speak(data)
    message = room&.messages&.create!(user: current_user, body: data["body"])
    return if message.nil?

    ActionCable.server.broadcast("room_#{message.room_id}", { message: message })
  end

  private

  def find_room
    board = current_user.boards.find_by(id: params[:board_id])
    room = board&.rooms&.find_by(id: params[:room_id])
    @room_id = room&.id
    room
  end

  def room
    Room.find_by(id: @room_id)
  end
end
