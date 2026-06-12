class Admin::SessionsController < ApplicationController
  skip_forgery_protection only: :exit
  layout "application"

  def new
  end

  def create
    if valid_admin_credentials?(params[:username], params[:password])
      session[:admin_authenticated] = true
      session[:admin_display_name] = params[:username].to_s
      session[:admin_last_seen_at] = Time.current.to_i
      redirect_to admin_root_path, notice: "Welcome back, admin."
    else
      flash.now[:alert] = "Invalid username or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to admin_new_session_path, notice: "Signed out successfully."
  end

  def exit
    reset_session
    head :no_content
  end

  private

  def valid_admin_credentials?(username, password)
    user = admin_username
    pass = admin_password
    return false if user.blank? || pass.blank?

    secure_compare(username.to_s, user.to_s) && secure_compare(password.to_s, pass.to_s)
  end

  def secure_compare(left, right)
    ActiveSupport::SecurityUtils.secure_compare(
      Digest::SHA256.hexdigest(left),
      Digest::SHA256.hexdigest(right)
    )
  end

  def admin_username
    ENV["ADMIN_USERNAME"].presence ||
      Rails.application.credentials.dig(:admin, :username).presence ||
      SiteSetting.current.admin_username.presence ||
      (Rails.env.development? ? "admin" : nil)
  end

  def admin_password
    ENV["ADMIN_PASSWORD"].presence ||
      Rails.application.credentials.dig(:admin, :password).presence ||
      SiteSetting.current.admin_password.presence ||
      (Rails.env.development? ? "change-me" : nil)
  end
end
