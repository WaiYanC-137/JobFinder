class TLocation < ApplicationRecord

    has_many :users, class_name: 'MUser', foreign_key: 'city'
    has_many :user_skills
    has_many :skills, through: :user_skills
end
