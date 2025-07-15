class SignalingChannel < ApplicationCable::Channel
  def subscribed
    room = find_room
    return reject unless room

    stream_from "room_#{room.id}_signaling"
  end

  def signal(data)
    return if room.nil?

    ActionCable.server.broadcast("room_#{room.id}_signaling", {
      from: current_user.id,
      type: data["type"],
      payload: data["payload"]
    })
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
