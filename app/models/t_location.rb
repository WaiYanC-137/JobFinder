class TLocation < ApplicationRecord

        has_many :m_users, class_name: 'MUser', foreign_key: 'city'
        has_many :m_companies, class_name: 'MCompany', foreign_key: 'city'
        validates :city, presence: { message: ERROR_MESSAGES[:blank] }


end
