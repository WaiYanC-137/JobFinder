class MUser < ApplicationRecord
  has_one_attached :profile_picture
  belongs_to :location, class_name: 'TLocation', foreign_key: 'city', optional: true

  has_and_belongs_to_many :t_skills
  belongs_to :category, class_name: 'TCategory', foreign_key: 't_category_id', optional: true
  has_secure_password validations: false

  validates :name, presence: true

  # Email validations
  validates :email, presence: { message: :blank }, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: :invalid }, if: -> { email.present? }

  # Password validations
  validates :password, presence: { message: :blank }, on: :create
  validates :password, length: { minimum: 6, message: :too_short }, if: -> { password.present? }, on: :create
end
