class MUser < ApplicationRecord

  has_one_attached :profile_picture
  belongs_to :location, class_name: 'TLocation', foreign_key: 'city', optional: true

  has_and_belongs_to_many :t_skills


  belongs_to :category, class_name: 'TCategory', foreign_key: 't_category_id', optional: true
  
  
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create # password is required on create

end
