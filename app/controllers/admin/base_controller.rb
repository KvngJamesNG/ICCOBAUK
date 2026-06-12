class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  before_action :enforce_admin_session_timeout!
  helper_method :admin_signed_in?

  ADMIN_IDLE_TIMEOUT = 20.minutes

  private

  def authenticate_admin!
    return if admin_signed_in?

    redirect_to admin_new_session_path, alert: "Please sign in to continue."
  end

  def enforce_admin_session_timeout!
    return unless session[:admin_authenticated] == true

    last_seen_at = session[:admin_last_seen_at].presence
    now = Time.current.to_i

    if last_seen_at.present? && now - last_seen_at.to_i > ADMIN_IDLE_TIMEOUT.to_i
      reset_session
      redirect_to admin_new_session_path, alert: "Your session expired due to inactivity. Please sign in again."
      return
    end

    session[:admin_last_seen_at] = now
  end

  def admin_signed_in?
    session[:admin_authenticated] == true
  end

  def valid_admin_credentials?(username, password)
    return false if admin_username.blank? || admin_password.blank?

    secure_compare(username.to_s, admin_username.to_s) && secure_compare(password.to_s, admin_password.to_s)
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
