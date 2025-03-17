class TCategory < ApplicationRecord

    validates :title, presence: { message: ERROR_MESSAGES[:blank] }

    has_many :m_users, class_name: 'MUser', foreign_key: 't_category_id'
end
