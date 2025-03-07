class TJobOffer < ApplicationRecord

    has_and_belongs_to_many :t_skills, join_table: 't_job_offers_skills'
    has_and_belongs_to_many :m_users, join_table: :m_users_t_job_offers
    belongs_to :company, class_name: 'MCompany', foreign_key: 'company_id'
    belongs_to :location, class_name: 'TLocation', foreign_key: 'location_id'
    belongs_to :category, class_name: 'TCategory', foreign_key: 'category_id'

    validates :title, presence: true, length: { maximum: 100 }
    validates :description, presence: true, length: { minimum: 20 }
    validates :category, presence: true
    validates :location, presence: true
  
end
