class Api::V1::AuthController < ApplicationController
  include Authenticable

  def signup
    user = User.new(user_params)
    return render json: { errors: user.errors.full_messages }, status: :unprocessable_entity unless user.save

    render json: { token: encode_token(user), user: user.slice(:id, :email) }, status: :created
  end

  def login
    user = User.find_by(email: params[:email])
    return render json: { error: "Invalid credentials" }, status: :unauthorized unless user&.authenticate(params[:password])

    render json: { token: encode_token(user), user: user.slice(:id, :email) }
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
