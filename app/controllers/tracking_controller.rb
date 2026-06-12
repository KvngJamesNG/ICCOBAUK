class TrackingController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create_click
    ClickEvent.create(
      path: params[:path],
      target_url: params[:target_url],
      element_text: params[:element_text].to_s.truncate(150),
      ip_address: request.remote_ip,
      device_type: infer_device_type(request.user_agent)
    )

    head :ok
  rescue StandardError
    head :ok
  end

  private

  def infer_device_type(user_agent)
    ua = user_agent.to_s.downcase
    return "tablet" if ua.match?(/ipad|tablet/)
    return "mobile" if ua.match?(/mobi|android|iphone/)

    "desktop"
  end
end
