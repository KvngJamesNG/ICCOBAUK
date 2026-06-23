class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  before_action :purge_expired_writer_accounts!
  before_action :enforce_admin_session_timeout!
  before_action :enforce_writer_account_validity!
  before_action :authorize_admin_area!
  helper_method :admin_signed_in?, :admin_user?, :writer_signed_in?, :current_admin_role

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

  def enforce_writer_account_validity!
    return unless writer_signed_in?

    writer_account = current_writer_account
    return if writer_account.present? && !writer_account.expired?

    reset_session
    redirect_to admin_new_session_path, alert: "Your temporary writer account has expired."
  end

  def purge_expired_writer_accounts!
    cache_key = "last_writer_purge_at"
    last_purge = Rails.cache.read(cache_key).to_i
    return if (Time.current.to_i - last_purge) < 5.minutes.to_i

    TempWriterAccount.purge_expired!
    Rails.cache.write(cache_key, Time.current.to_i, expires_in: 10.minutes)
  rescue StandardError
    nil
  end

  def authorize_admin_area!
    return if admin_user?
    return if writer_signed_in? && writer_allowed?

    redirect_to admin_articles_path, alert: "You only have article writing access."
  end

  def admin_signed_in?
    session[:admin_authenticated] == true
  end

  def admin_user?
    admin_signed_in? && current_admin_role == "admin"
  end

  def writer_signed_in?
    admin_signed_in? && current_admin_role == "writer"
  end

  def current_admin_role
    role = session[:admin_role].to_s
    return role if role.present?

    session[:writer_account_id].present? ? "writer" : "admin"
  end

  def writer_allowed?
    false
  end

  def current_writer_account
    @current_writer_account ||= TempWriterAccount.find_by(id: session[:writer_account_id])
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
