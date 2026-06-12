article = Article.find_or_initialize_by(title: "Welcome to ICCOBA UK/Europe")
article.summary = "Welcome note and updates for the ICCOBA UK and Europe community."
article.body = "This is your first dynamic article. You can edit this content from the admin area."
article.author_name = "ICCOBA Admin"
article.category = "News"
article.published_on = Date.today
article.save!

gallery_image = GalleryImage.find_or_initialize_by(title: "ICCOBA Community")
gallery_image.caption = "First dynamic gallery image. Replace this from admin."

seed_image_path = Rails.root.join("app/assets/images/gallery/presidentworldwide.jpg")
if seed_image_path.exist? && !gallery_image.image.attached?
	gallery_image.image.attach(
		io: File.open(seed_image_path),
		filename: "presidentworldwide.jpg",
		content_type: "image/jpeg"
	)
end

gallery_image.save!

slider_image = SliderImage.find_or_initialize_by(title: "ICCOBA Welcome Slider")
slider_image.caption = "Homepage slider image managed by admin"
slider_image.position = 1
slider_image.active = true
if seed_image_path.exist? && !slider_image.image.attached?
	slider_image.image.attach(
		io: File.open(seed_image_path),
		filename: "presidentworldwide.jpg",
		content_type: "image/jpeg"
	)
end
slider_image.save!

privacy_page = InfoPage.find_or_initialize_by(slug: "privacy-policy")
privacy_page.title = "Privacy Policy"
privacy_page.published = true
privacy_page.body = <<~TEXT
	This Privacy Policy explains how ICCOBA UK/Europe handles personal information on this website.

	1. Data We Collect
	- Contact details you submit voluntarily (for example, via contact forms or direct email).
	- Basic technical data needed to run and secure the website.

	2. Why We Process Data
	- To respond to your enquiries.
	- To manage association communications and website operations.
	- To improve service quality while respecting your rights.

	3. Cookie Use and Consent
	- Essential cookies are used for website functionality.
	- Optional analytics cookies are used only when you explicitly accept them.

	4. Your GDPR Rights
	You may request access, correction, deletion, restriction, or portability of your personal data,
	and you may object to processing where applicable.

	5. Data Retention
	Personal data is retained only for as long as necessary for the purpose collected and legal obligations.

	6. Contact for Privacy Requests
	Email: company@llw-cs.com

	This policy can be updated by website administrators to reflect legal or operational changes.
TEXT
privacy_page.save!

data_rights_page = InfoPage.find_or_initialize_by(slug: "data-subject-rights")
data_rights_page.title = "Data Subject Rights (GDPR)"
data_rights_page.published = true
data_rights_page.body = <<~TEXT
	Under GDPR, you have rights over your personal data held by ICCOBA UK/Europe.

	Your key rights include:
	- Right of access (request a copy of your personal data)
	- Right to rectification (correct inaccurate or incomplete data)
	- Right to erasure (request deletion where applicable)
	- Right to restrict processing
	- Right to data portability
	- Right to object to certain processing
	- Right to withdraw consent at any time (where consent is the legal basis)

	How to submit a request:
	1. Email your request to company@llw-cs.com.
	2. Include your full name, contact details, and the right you want to exercise.
	3. Provide enough detail for us to identify your records.

	Verification and response timeline:
	- We may request identity verification before processing your request.
	- We aim to respond within one month, as required by GDPR (subject to lawful extensions).

	Complaints:
	If you are not satisfied with our response, you may lodge a complaint with your supervisory authority.
TEXT
data_rights_page.save!

gdpr_admin_page = InfoPage.find_or_initialize_by(slug: "gdpr-admin-workflow")
gdpr_admin_page.title = "GDPR Admin Workflow"
gdpr_admin_page.published = false
gdpr_admin_page.body = <<~TEXT
	Internal workflow notes for administrators handling GDPR requests.

	1. Intake
	- Record request date/time and request type.
	- Acknowledge receipt.

	2. Identity Verification
	- Verify requester identity before data disclosure or deletion.

	3. Scope Assessment
	- Determine data systems impacted (articles/comments/forms/emails etc.).

	4. Action
	- Access: compile requested data.
	- Rectification: update inaccurate records.
	- Erasure: remove data unless legal exceptions apply.
	- Restriction/objection: mark and enforce processing limits.

	5. Completion
	- Respond within GDPR timeline.
	- Log completion date and actions taken.
TEXT
gdpr_admin_page.save!

site_setting = SiteSetting.current
site_setting.admin_username = "admin"
site_setting.admin_password = "change-me"
site_setting.theme_document_title ||= "Theme Document"
site_setting.save!

puts "Seeded admin login: username=admin password=change-me"
