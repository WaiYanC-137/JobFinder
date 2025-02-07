class MCompany < ApplicationRecord
  has_one_attached :logo
  has_secure_password validations: false

  validates :name, presence: true

  # Email validations
  validates :email, presence: { message: :blank }, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: :invalid }, if: -> { email.present? }

  # Password validations
  validates :password, presence: { message: :blank }, on: :create
  validates :password, length: { minimum: 6, message: :too_short }, if: -> { password.present? }, on: :create
end
