class ArticleLike < ApplicationRecord
  belongs_to :article

  REACTIONS = %w[up down love].freeze

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :article_id }
  validates :reaction, inclusion: { in: REACTIONS }

  def emoji
    case reaction
    when "up" then "👍"
    when "down" then "👎"
    when "love" then "❤️"
    else "👍"
    end
  end
end
