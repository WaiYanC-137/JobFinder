class TCategory < ApplicationRecord

    validates :title, presence: true, uniqueness: true, length: { maximum: 50 }
    has_many :m_users, class_name: 'MUser', foreign_key: 't_category_id'
end
