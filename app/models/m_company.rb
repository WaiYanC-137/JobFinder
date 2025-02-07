class MCompany < ApplicationRecord
  has_one_attached :logo
  has_secure_password validations: false

  validates :name, presence: true
   validates :phone, presence: true
  validates :phone, phony_plausible: true  # Checks for plausibility (valid number in the country)
  

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







  private

  def phone_format
    if phone.present?
      # Myanmar regex for +95 or 09
      myanmar_regex = /\A(\+95\d{9}|\d{10})\z/  # Either +95XXXXXXXXX or 09XXXXXXXXX
      japan_regex = /\A\+81\d{9,10}\z/  # Japan phone number format: +81XXXXXXXXXX or +81XXXXXXXXXXX

      unless phone.match?(myanmar_regex) || phone.match?(japan_regex)
        errors.add(:phone, "無効な電話番号です。ミャンマーか日本の番号を入力してください")
      end
    end
  end
end
