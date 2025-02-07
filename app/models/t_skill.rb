class TSkill < ApplicationRecord
    has_and_belongs_to_many :m_users
    has_and_belongs_to_many :t_job_offers
end
