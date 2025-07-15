require "test_helper"

class ConnectionTest < ActionCable::Connection::TestCase
  tests ApplicationCable::Connection
  test "connects with a valid token" do
    user = User.create!(email: "cable@user.dev", password: "secret123", password_confirmation: "secret123")
    secret = ENV.fetch("JWT_SECRET") { Rails.application.credentials.secret_key_base }
    token = JWT.encode({ user_id: user.id }, secret, "HS256")

    connect params: { token: token }

    assert_equal user.id, connection.current_user.id
  end

  test "rejects without a token" do
    assert_reject_connection { connect }
  end

  test "rejects with an invalid token" do
    assert_reject_connection { connect params: { token: "garbage" } }
  end
end
