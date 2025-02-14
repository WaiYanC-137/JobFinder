class MUser < ApplicationRecord
  has_one_attached :profile_picture
  belongs_to :location, class_name: 'TLocation', foreign_key: 'location_id', optional: true
  has_and_belongs_to_many :t_job_offers, join_table: :m_users_t_job_offers
  has_and_belongs_to_many :t_skills
  belongs_to :category, class_name: 'TCategory', foreign_key: 'category_id', optional: true
  has_secure_password validations: false

  validates :name, presence: true
  
  # Email validations
  validates :email, presence: { message: :blank }, uniqueness: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]{2,}\z/i, message: :invalid }, if: -> { email.present? }

  # Password validations
 validates :password, presence: { message: :blank }, on: :create
 validates :password, length: { minimum: 6, message: :too_short }, if: -> { password.present? }, on: :create

  # Password validations
  validates :password_confirmation, presence: { message: :blank }, on: :create
  validates :password_confirmation, presence: { message: :blank }, if: -> { password.present? }
  validates :password_confirmation, length: { minimum: 6, message: :too_short }, if: -> { password_confirmation.present? }
  validates :password, confirmation: { message: :mismatch }, if: -> { password.present? && password_confirmation.present? }


end
