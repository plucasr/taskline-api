require "test_helper"

class BoardsTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "boards@user.dev", password: "secret123", password_confirmation: "secret123")
    @token = token_for(@user)
  end

  test "index returns only own boards" do
    mine = Board.create!(name: "Mine")
    @user.board_memberships.create!(board: mine, role: :owner)
    other = Board.create!(name: "Other")

    get "/api/v1/boards", headers: auth_headers

    assert_response :ok
    names = response.parsed_body.map { |b| b["name"] }
    assert_includes names, "Mine"
    assert_not_includes names, "Other"
  end

  test "create makes the user owner" do
    post "/api/v1/boards", params: { name: "New Board" }, headers: auth_headers

    assert_response :created
    assert @user.owner_of?(Board.find(response.parsed_body["id"]))
  end

  test "show includes columns and cards" do
    board = Board.create!(name: "With Columns")
    @user.board_memberships.create!(board: board, role: :owner)
    column = board.columns.create!(name: "Todo", position: 0)
    column.cards.create!(title: "Card A", position: 0)

    get "/api/v1/boards/#{board.id}", headers: auth_headers

    assert_response :ok
    assert_equal "Todo", response.parsed_body["columns"].first["name"]
    assert_equal "Card A", response.parsed_body["columns"].first["cards"].first["title"]
  end

  test "destroy is forbidden for non-owners" do
    owner = User.create!(email: "owner@user.dev", password: "secret123", password_confirmation: "secret123")
    board = Board.create!(name: "Owned")
    owner.board_memberships.create!(board: board, role: :owner)
    @user.board_memberships.create!(board: board, role: :member)

    delete "/api/v1/boards/#{board.id}", headers: auth_headers

    assert_response :forbidden
  end

  test "requires authentication" do
    get "/api/v1/boards"

    assert_response :unauthorized
  end

  private

  def auth_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  def token_for(user)
    post "/api/v1/login", params: { email: user.email, password: "secret123" }
    response.parsed_body["token"]
  end
end

class ErrorFormatTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "errors@user.dev", password: "secret123", password_confirmation: "secret123")
    post "/api/v1/login", params: { email: @user.email, password: "secret123" }
    @headers = { "Authorization" => "Bearer #{response.parsed_body['token']}" }
  end

  test "missing record returns not found shape" do
    get "/api/v1/boards/99999", headers: @headers

    assert_response :not_found
    assert_equal "Not found", response.parsed_body["error"]
  end

  test "validation failure returns errors array" do
    post "/api/v1/boards", params: { name: "" }, headers: @headers

    assert_response :unprocessable_entity
    assert response.parsed_body["errors"].is_a?(Array)
  end
end
