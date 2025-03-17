class TJobOffer < ApplicationRecord
    has_and_belongs_to_many :t_skills, join_table: 't_job_offers_skills'
    has_and_belongs_to_many :m_users, join_table: :m_users_t_job_offers
    belongs_to :company, class_name: 'MCompany', foreign_key: 'company_id'
    belongs_to :location, class_name: 'TLocation', foreign_key: 'location_id', optional: true
    belongs_to :category, class_name: 'TCategory', foreign_key: 'category_id', optional: true
  
    # Title validation: Presence, Length (30-100)
    validates :title, presence: { message: "#{ERROR_MESSAGES[:blank]}" }
    validates :title, length: { minimum: 10, maximum: 100, message: "#{ERROR_MESSAGES[:too_short]}" }, if: -> { title.present? }
  
    # Category validation: Presence
    validates :category, presence: { message: "#{ERROR_MESSAGES[:blank]}" }
  
    # Location validation: Presence
    validates :location, presence: { message: "#{ERROR_MESSAGES[:blank]}" }
  
    # Description validation: Presence, Length (30-100)
    validates :description, presence: { message: "#{ERROR_MESSAGES[:blank]}" }
    validates :description, length: { minimum: 30, maximum: 500, message: "#{ERROR_MESSAGES[:too_short]}" }, if: -> { description.present? }
  
    # T Skills validation: Presence
    validates :t_skills, presence: { message: "#{ERROR_MESSAGES[:blank]}" }
    
     # Validating presence
     validates :minsalary, presence: { message: "#{ERROR_MESSAGES[:blank]}" }
     validates :maxsalary, presence: { message: "#{ERROR_MESSAGES[:blank]}" }
  # Validating length (minimum and maximum digits)
  validates :minsalary, length: { minimum: 8, message: "#{ERROR_MESSAGES[:too_short]}" }, if: -> { minsalary.present? }
  validates :maxsalary, length: { minimum: 8, message: "#{ERROR_MESSAGES[:too_short]}" }, if: -> { maxsalary.present? }

  validates :minsalary, length: { maximum: 10, message: "#{ERROR_MESSAGES[:too_long]}" }, if: -> { minsalary.present? }
  validates :maxsalary, length: { maximum: 10, message: "#{ERROR_MESSAGES[:too_long]}" }, if: -> { maxsalary.present? }


  # Custom validation for minsalary being less than or equal to maxsalary
  validate :minsalary_less_than_maxsalary

  private

  def minsalary_less_than_maxsalary
    if minsalary.present? && maxsalary.present? && minsalary > maxsalary
      errors.add(:minsalary, "must be less than or equal to the maximum salary")
    end
  end
    
end
  