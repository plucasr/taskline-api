class Api::V1::MessagesController < Api::V1::BaseController
  before_action :set_room

  def index
    render json: @room.messages
  end

  private

  def set_room
    board = current_user.boards.find(params[:board_id])
    @room = board.rooms.find(params[:room_id])
  end
end
