class MCompany < ApplicationRecord
  attr_accessor :remember_token
  has_one_attached :logo
  has_secure_password validations: false
  belongs_to :location, class_name: 'TLocation', foreign_key: 'location_id', optional: true
  has_many :t_job_offers, foreign_key: 'company_id'

  validates :name, presence: true
  validates :phone, presence: true
  # Checks for plausibility (valid number in the country)
  validate :phone_format  # Custom validation for phone format

  # Email validations
  validates :email, presence: { message: :blank }, uniqueness: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]{2,}\z/i, message: :invalid }, if: -> { email.present? }

  # Password validations
  validates :password, presence: { message: :blank }, on: :create
  validates :password, length: { minimum: 6, message: :too_short }, if: -> { password.present? }, on: :create

  # Password confirmation validations
  validates :password_confirmation, presence: { message: :blank }, on: :create
  validates :password_confirmation, presence: { message: :blank }, if: -> { password.present? }
  validates :password_confirmation, length: { minimum: 6, message: :too_short }, if: -> { password_confirmation.present? }
  validates :password, confirmation: { message: :mismatch }, if: -> { password.present? && password_confirmation.present? }

  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update(remember_digest: BCrypt::Password.create(remember_token))
  end

  # Verifies if a given token matches the stored digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Clears the remember token
  def forget
    update(remember_digest: nil)
  end


  private

  def phone_format
    if phone.present?
      Rails.logger.debug "Original phone number: #{phone}"

      # Normalize the phone number (remove spaces and dashes)
      normalized_phone = phone.gsub(/[\s-]/, "")
      Rails.logger.debug "Normalized phone number: #{normalized_phone}"
  
      # Myanmar phone number rules:
      # - Local format: "09" followed by 9 digits (total: 11 digits)
      # - International format: "+959" followed by 9 digits (total: 12 digits)
      myanmar_regex = /\A(09\d{9}|\+959\d{9})\z/
  
      unless normalized_phone.match?(myanmar_regex)
        errors.add(:phone, "無効な電話番号です。ミャンマーの正しい形式で入力してください")
      end
    end
  end
  
  # Generates a token and stores its hash in the database
  
  
end