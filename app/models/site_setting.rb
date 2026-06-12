class SiteSetting < ApplicationRecord
  has_one_attached :theme_document

  DEFAULT_HOME_CONVENTION_TEXT = "12th-14th September 2025 Convention".freeze
  DEFAULT_HOME_SPONSOR_TEXT = "Proudly Sponsored by LLW Consultancy Ltd".freeze

  validates :admin_username, presence: true, if: -> { admin_password.present? }
  validates :admin_password, presence: true, if: -> { admin_username.present? }

  def self.current
    first_or_create!
  end

  def home_convention_text_value
    home_convention_text.presence || DEFAULT_HOME_CONVENTION_TEXT
  end

  def home_sponsor_text_value
    home_sponsor_text.presence || DEFAULT_HOME_SPONSOR_TEXT
  end
end
