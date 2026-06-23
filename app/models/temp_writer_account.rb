class TempWriterAccount < ApplicationRecord
  USERNAME_FORMAT = /\A[a-zA-Z0-9_\-\.]+\z/
  PASSWORD_WORDS = %w[
    amber
    atlas
    breeze
    cedar
    comet
    coral
    delta
    ember
    falcon
    harbor
    jasmine
    lagoon
    maple
    nebula
    nova
    orbit
    prism
    quartz
    ripple
    summit
    vector
    willow
    zenith
  ].freeze
  PASSWORD_SYMBOLS = %w[! @ # $ % & *].freeze

  attr_reader :password

  before_validation :assign_default_username
  before_validation :normalize_username
  before_validation :normalize_email
  before_validation :set_email_digest
  before_validation :hash_password, if: :password_present?
  before_destroy :archive_legitimate_email

  validates :username, presence: true, uniqueness: { case_sensitive: false }, format: { with: USERNAME_FORMAT }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email_digest, presence: true, uniqueness: true
  validates :password_salt, :password_digest, :expires_at, presence: true
  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?

  scope :active, -> { where("expires_at > ?", Time.current) }
  scope :expired, -> { where("expires_at <= ?", Time.current) }

  def password=(raw_password)
    @password = raw_password.to_s
  end

  def email
    decrypt_email(email_ciphertext)
  end

  def email=(raw_email)
    normalized = raw_email.to_s.strip.downcase
    self.email_ciphertext = normalized.present? ? encrypt_email(normalized) : nil
  end

  def expired?
    expires_at <= Time.current
  end

  def authenticate(raw_password)
    return false if password_salt.blank? || password_digest.blank?

    candidate = Digest::SHA256.hexdigest("#{password_salt}#{raw_password}")
    ActiveSupport::SecurityUtils.secure_compare(candidate, password_digest)
  rescue StandardError
    false
  end

  def self.generate_phrase_password
    first_word = PASSWORD_WORDS.sample.capitalize
    second_word = PASSWORD_WORDS.sample.capitalize
    first_symbol = PASSWORD_SYMBOLS.sample
    second_symbol = PASSWORD_SYMBOLS.sample
    digits = format("%02d", SecureRandom.random_number(100))
    alpha_numeric_tail = SecureRandom.alphanumeric(3)

    "#{first_word}#{first_symbol}#{second_word}#{digits}#{second_symbol}#{alpha_numeric_tail}"
  end

  def self.purge_expired!
    expired.find_each(&:destroy)
  end

  private

  def email_encryptor
    @email_encryptor ||= begin
      secret = Rails.application.secret_key_base
      key = ActiveSupport::KeyGenerator.new(secret).generate_key("writer-email-protection", ActiveSupport::MessageEncryptor.key_len)
      ActiveSupport::MessageEncryptor.new(key)
    end
  end

  def encrypt_email(value)
    email_encryptor.encrypt_and_sign(value)
  end

  def decrypt_email(value)
    return nil if value.blank?

    email_encryptor.decrypt_and_verify(value)
  rescue StandardError
    nil
  end

  def assign_default_username
    return if username.present?
    return if email.blank?

    local_part = email.to_s.split("@").first.to_s.downcase.gsub(/[^a-z0-9]+/, "_").gsub(/\A_+|_+\z/, "")
    base = local_part.presence || "writer"

    self.username = base
    suffix = 1
    while self.class.where.not(id: id).exists?(username: username)
      self.username = "#{base}_#{suffix}"
      suffix += 1
    end
  end

  def password_required?
    new_record? || password_present?
  end

  def password_present?
    @password.present?
  end

  def normalize_username
    self.username = username.to_s.strip.downcase
  end

  def normalize_email
    self.email = email
  end

  def set_email_digest
    normalized_email = email.to_s.strip.downcase
    return if normalized_email.blank?

    self.email_digest = Digest::SHA256.hexdigest(normalized_email)
  end

  def hash_password
    self.password_salt = SecureRandom.hex(16)
    self.password_digest = Digest::SHA256.hexdigest("#{password_salt}#{@password}")
  end

  def archive_legitimate_email
    WriterEmailArchive.record!(
      username: username,
      email: email,
      expires_at: expires_at
    )
  end
end
