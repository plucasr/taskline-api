module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user
    end

    private

    def find_user
      token = request.query_parameters["token"].to_s.split(" ").last
      payload = JWT.decode(token, secret, true, algorithm: "HS256").first
      User.find(payload["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      reject_unauthorized_connection
    end

    def secret
      ENV.fetch("JWT_SECRET") { Rails.application.credentials.secret_key_base }
    end
  end
end
