class Api::V1::CardsController < Api::V1::BaseController
  before_action :set_column
  before_action :set_card, only: %i[update destroy move]

  def index
    render json: @column.cards
  end

  def create
    card = @column.cards.new(card_params)
    return render_validation_errors(card) unless card.save

    render json: card, status: :created
  end

  def update
    return render_validation_errors(@card) unless @card.update(card_params)

    render json: @card
  end

  def move
    target_column = @column.board.columns.find_by(id: params[:to_column_id])
    return render json: { error: "Column not found on this board" }, status: :not_found if target_column.nil?

    @card.update!(column: target_column, position: params[:position] || 0)
    render json: @card
  end

  def destroy
    @card.destroy
    head :no_content
  end

  private

  def set_column
    board = current_user.boards.find(params[:board_id])
    @column = board.columns.find(params[:column_id])
  end

  def set_card
    @card = @column.cards.find(params[:id])
  end

  def card_params
    params.permit(:title, :description, :position)
  end
end
