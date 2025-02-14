class HomeController < ApplicationController
  def index
  end

  def register
  end

  def userlist
    # Initialize skill_ids as an empty array if none are selected
    @skill_ids = params[:skill_ids] || []
    
    # Load filter options
    @categories = TCategory.pluck(:title, :id)
    @skills = TSkill.all  # Ensure you are fetching the skills correctly
    @locations = TLocation.pluck(:city, :id)
    
    # Initialize filtered users as all users
    filtered_users = MUser.all

    # Fetch filter parameters
    category_id = params[:category_id]
    location_id = params[:location_id]
    @skill_ids = params[:skill_ids] || []
    
    # Apply category filter if present
    filtered_users = filtered_users.where(category_id: category_id) if category_id.present?

    # Apply location filter if present
    filtered_users = filtered_users.where(location_id: location_id) if location_id.present?

    # Apply skill filter if present and multiple skills are selected
    if @skill_ids.present? && @skill_ids.any?
      filtered_users = filtered_users.joins(:t_skills).where(t_skills: { id: @skill_ids })
    end

    # Count filtered users for pagination display
    @total_users_count = filtered_users.count

    # Paginate users
    @m_users = filtered_users.page(params[:page]).per(1) # Adjust per-page as needed

    # Pass back filter parameters for the form
    @category_id = category_id
    @location_id = location_id
  end

  def joblist
    # Initialize skill_ids as an empty array if none are selected
    @skill_ids = params[:skill_ids] || []

    # Load filter options
    @categories = TCategory.pluck(:title, :id)
    @skills = TSkill.all  # Ensure you are fetching the skills correctly
    @locations = TLocation.pluck(:city, :id)

    # Start with all job offers
    @joboffers = TJobOffer.all

    # Fetch filter parameters
    category_id = params[:category_id]
    location_id = params[:location_id]
    @skill_ids = params[:skill_ids] || []
    min_salary = params[:min_salary]
    max_salary = params[:max_salary]

    # Apply category filter if present
    @joboffers = @joboffers.where(category_id: category_id) if category_id.present?

    # Apply location filter if present
    @joboffers = @joboffers.where(location_id: location_id) if location_id.present?

    # Apply skill filter if present and multiple skills are selected
    if @skill_ids.present? && @skill_ids.any?
      @joboffers = @joboffers.joins(:t_skills).where(t_skills: { id: @skill_ids })
    end

    # Apply salary range filter if present
    @joboffers = @joboffers.where("minsalary >= ?", min_salary) if min_salary.present?
    @joboffers = @joboffers.where("maxsalary <= ?", max_salary) if max_salary.present?
    @joboffers = @joboffers.order(created_at: :desc)

    # Count total filtered job offers
    @total_joboffers_count = @joboffers.count

    # Paginate filtered job offers
    @joboffers = @joboffers.page(params[:page]).per(1) # Adjust the per-page value as needed

    # Pass back filter parameters for the form
    @category_id = category_id
    @location_id = location_id
    @min_salary = min_salary
    @max_salary = max_salary
  end
end
