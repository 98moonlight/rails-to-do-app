# frozen_string_literal: true

# header: { 'Authorization': 'Bearer <token>' }

# Helper methods to run before most routes (e.g. authorisation)
class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    JWT.encode(payload, secret_key)
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    nil unless auth_header

    token = auth_header.split(' ')[1]
    begin
      JWT.decode(token, secret_key, true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def logged_in_user
    return unless decoded_token

    user_id = decoded_token[0]['user_id']
    @user = User.find_by(id: user_id)
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  private

  def secret_key
    if ENV['RAILS_ENV'] == 'test'
      'test-env-password'
    else
      Rails.application.credentials.secret_key
    end
  end
end
