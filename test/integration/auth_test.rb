require "test_helper"

class AuthTest < ActionDispatch::IntegrationTest
  test "signup returns a token" do
    post "/api/v1/signup", params: { email: "new@user.dev", password: "secret123", password_confirmation: "secret123" }

    assert_response :created
    assert response.parsed_body["token"].present?
  end

  test "signup rejects mismatched passwords" do
    post "/api/v1/signup", params: { email: "bad@user.dev", password: "a", password_confirmation: "b" }

    assert_response :unprocessable_entity
  end

  test "login returns a token for valid credentials" do
    User.create!(email: "login@user.dev", password: "secret123", password_confirmation: "secret123")

    post "/api/v1/login", params: { email: "login@user.dev", password: "secret123" }

    assert_response :ok
    assert response.parsed_body["token"].present?
  end

  test "login rejects wrong password" do
    User.create!(email: "nope@user.dev", password: "secret123", password_confirmation: "secret123")

    post "/api/v1/login", params: { email: "nope@user.dev", password: "wrong" }

    assert_response :unauthorized
  end
end
