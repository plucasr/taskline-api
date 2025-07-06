class Api::V1::BoardsController < Api::V1::BaseController
  before_action :set_board, only: %i[show update destroy]

  def index
    render json: current_user.boards.includes(:board_memberships)
  end

  def show
    render json: @board.as_json(include: { columns: { include: :cards } })
  end

  def create
    board = Board.new(board_params)
    return render_validation_errors(board) unless board.save

    current_user.board_memberships.create!(board: board, role: :owner)
    render json: board, status: :created
  end

  def update
    return render_validation_errors(@board) unless @board.update(board_params)

    render json: @board
  end

  def destroy
    unless current_user.owner_of?(@board)
      return render json: { error: "Only the owner can delete the board" }, status: :forbidden
    end

    @board.destroy
    head :no_content
  end

  private

  def set_board
    @board = current_user.boards.find(params[:id])
  end

  def board_params
    params.permit(:name)
  end
end
