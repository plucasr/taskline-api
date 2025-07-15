class PresenceChannel < ApplicationCable::Channel
  def subscribed
    board = find_board
    return reject unless board

    stream_from "board_#{board.id}_presence"
    broadcast_presence(board, "joined")
  end

  def unsubscribed
    broadcast_presence(board, "left") if @board_id
  end

  private

  def find_board
    board = current_user.boards.find_by(id: params[:board_id])
    @board_id = board&.id
    board
  end

  def board
    Board.find_by(id: @board_id)
  end

  def broadcast_presence(board, event)
    ActionCable.server.broadcast("board_#{board.id}_presence", {
      event: event,
      user: { id: current_user.id, email: current_user.email }
    })
  end
end
