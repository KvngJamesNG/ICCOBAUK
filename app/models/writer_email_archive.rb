class WriterEmailArchive < ApplicationRecord
  validates :email, :email_digest, presence: true
  validates :email_digest, uniqueness: true

  def email
    decrypt_email(email_ciphertext)
  end

  def email=(raw_email)
    normalized = raw_email.to_s.strip.downcase
    self.email_ciphertext = normalized.present? ? encrypt_email(normalized) : nil
  end

  def self.record!(username:, email:, expires_at:)
    normalized_email = email.to_s.strip.downcase
    return if normalized_email.blank?

    digest = Digest::SHA256.hexdigest(normalized_email)
    archive = find_or_initialize_by(email_digest: digest)

    archive.email = normalized_email
    archive.last_username = username.to_s.strip.downcase.presence
    archive.last_expires_at = expires_at
    archive.archived_at = Time.current
    archive.save!
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
end
