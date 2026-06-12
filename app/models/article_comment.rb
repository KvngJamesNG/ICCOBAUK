class ArticleComment < ApplicationRecord
  belongs_to :article

  validates :email, :content, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :recent, -> { order(created_at: :desc) }
end
