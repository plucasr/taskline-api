class Api::V1::ColumnsController < Api::V1::BaseController
  before_action :set_board
  before_action :set_column, only: %i[update destroy]

  def index
    render json: @board.columns
  end

  def create
    column = @board.columns.new(column_params)
    return render json: { errors: column.errors.full_messages }, status: :unprocessable_entity unless column.save

    render json: column, status: :created
  end

  def update
    return render json: { errors: @column.errors.full_messages }, status: :unprocessable_entity unless @column.update(column_params)

    render json: @column
  end

  def destroy
    @column.destroy
    head :no_content
  end

  private

  def set_board
    @board = current_user.boards.find(params[:board_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Board not found" }, status: :not_found
  end

  def set_column
    @column = @board.columns.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Column not found" }, status: :not_found
  end

  def column_params
    params.permit(:name, :position)
  end
end
