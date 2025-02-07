class TJobOffer < ApplicationRecord

    has_and_belongs_to_many :t_skills
    belongs_to :location, class_name: 'TLocation', foreign_key: 'location_id'
    belongs_to :category, class_name: 'TCategory', foreign_key: 'category_id'
  
end
