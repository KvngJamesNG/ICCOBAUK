class SiteSetting < ApplicationRecord
  has_one_attached :theme_document

  validates :admin_username, presence: true, if: -> { admin_password.present? }
  validates :admin_password, presence: true, if: -> { admin_username.present? }

  def self.current
    first_or_create!
  end
end
