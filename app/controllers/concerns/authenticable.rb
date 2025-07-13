module Authenticable
  extend ActiveSupport::Concern

  SECRET = ENV.fetch("JWT_SECRET") { Rails.application.credentials.secret_key_base }

  def encode_token(user)
    JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, SECRET, "HS256")
  end

  def current_user
    token = request.headers["Authorization"]&.split(" ")&.last
    return nil if token.blank?

    payload = JWT.decode(token, SECRET, true, algorithm: "HS256").first
    User.find_by(id: payload["user_id"])
  rescue JWT::DecodeError
    nil
  end

  def authenticate!
    render json: { error: "Unauthorized" }, status: :unauthorized if current_user.nil?
  end
end
