module ApplicationHelper
	def site_name
		"ICCOBA UK"
	end

	def current_page_label
		return "Home" if current_page?(home_path)
		return "About" if current_page?(about_us_path)
		return "Blog" if current_page?(blog_home_path)
		return "Gallery" if current_page?(portfolio_overview_path)
		return "Contact" if current_page?(contact_us_path)
		return "Admin" if request.path.start_with?("/admin")

		action_name.to_s.tr("_", " ").split.map(&:capitalize).join(" ")
	end

	def page_title
		"#{current_page_label} | #{site_name}"
	end

	def admin_sidebar_link_class(link_path, current_path)
		active = current_path.start_with?(link_path) &&
		         (link_path != "/admin" || current_path == "/admin")
		active ? "admin-sidebar-link is-active" : "admin-sidebar-link"
	end
end
