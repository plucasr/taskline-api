require "test_helper"

class ColumnsCardsTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "cols@user.dev", password: "secret123", password_confirmation: "secret123")
    @board = Board.create!(name: "Board")
    @user.board_memberships.create!(board: @board, role: :owner)
    @col_a = @board.columns.create!(name: "A", position: 0)
    @col_b = @board.columns.create!(name: "B", position: 1)
    post "/api/v1/login", params: { email: @user.email, password: "secret123" }
    @headers = { "Authorization" => "Bearer #{response.parsed_body['token']}" }
  end

  test "create column" do
    post "/api/v1/boards/#{@board.id}/columns", params: { name: "Review", position: 2 }, headers: @headers

    assert_response :created
    assert_equal "Review", response.parsed_body["name"]
  end

  test "update column position" do
    patch "/api/v1/boards/#{@board.id}/columns/#{@col_b.id}", params: { position: 0 }, headers: @headers

    assert_response :ok
    assert_equal 0, response.parsed_body["position"]
  end

  test "create card in column" do
    post "/api/v1/boards/#{@board.id}/columns/#{@col_a.id}/cards",
         params: { title: "Task", position: 0 }, headers: @headers

    assert_response :created
    assert_equal "Task", response.parsed_body["title"]
  end

  test "move card to another column" do
    card = @col_a.cards.create!(title: "Moving", position: 0)

    patch "/api/v1/boards/#{@board.id}/columns/#{@col_a.id}/cards/#{card.id}/move",
          params: { to_column_id: @col_b.id, position: 0 }, headers: @headers

    assert_response :ok
    assert_equal @col_b.id, card.reload.column_id
  end

  test "reject move to a column outside the board" do
    other_board = Board.create!(name: "Other Board")
    foreign_column = other_board.columns.create!(name: "X", position: 0)
    card = @col_a.cards.create!(title: "Blocked", position: 0)

    patch "/api/v1/boards/#{@board.id}/columns/#{@col_a.id}/cards/#{card.id}/move",
          params: { to_column_id: foreign_column.id }, headers: @headers

    assert_response :not_found
  end

  test "delete card" do
    card = @col_a.cards.create!(title: "Gone", position: 0)

    delete "/api/v1/boards/#{@board.id}/columns/#{@col_a.id}/cards/#{card.id}", headers: @headers

    assert_response :no_content
    assert_nil Card.find_by(id: card.id)
  end
end
