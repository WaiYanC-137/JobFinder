class TSkill < ApplicationRecord
    has_and_belongs_to_many :m_users
end
