class Api::V1::RoomsController < Api::V1::BaseController
  before_action :set_board

  def index
    render json: @board.rooms
  end

  def create
    room = @board.rooms.new(room_params)
    return render_validation_errors(room) unless room.save

    render json: room, status: :created
  end

  private

  def set_board
    @board = current_user.boards.find(params[:board_id])
  end

  def room_params
    params.permit(:name)
  end
end
