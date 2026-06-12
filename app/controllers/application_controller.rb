class ApplicationController < ActionController::Base
	before_action :track_site_visit
	helper_method :admin_layout_active?

	private

	def track_site_visit
		return unless request.get?
		return unless request.format.html?
		return if request.path.start_with?("/rails/")
		return if request.path.start_with?("/admin")
		return if request.path.start_with?("/assets")

		SiteVisit.create(
			path: request.path,
			referrer: request.referer,
			ip_address: request.remote_ip,
			user_agent: request.user_agent,
			device_type: infer_device_type(request.user_agent)
		)
	rescue StandardError
		nil
	end

	def infer_device_type(user_agent)
		ua = user_agent.to_s.downcase
		return "tablet" if ua.match?(/ipad|tablet/)
		return "mobile" if ua.match?(/mobi|android|iphone/)

		"desktop"
	end

	def admin_layout_active?
		controller_path.start_with?("admin/") && session[:admin_authenticated] == true && !controller_path.start_with?("admin/sessions")
	end
end
