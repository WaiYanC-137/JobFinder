class HomeController < ApplicationController
  
  def index
  end

  def register
  end

  def userlist
    # Load filter options for categories, skills, and locations
    @categories = TCategory.pluck(:title, :id)
    @skills     = TSkill.pluck(:title, :id)
    @locations  = TLocation.pluck(:city, :id)
    
    # Start with all users (MUser)
    @m_users = MUser.all

    # Apply filters based on search form inputs
    if params[:category_id].present?
      @m_users = @m_users.where(category_id: params[:category_id])
    end

    if params[:skill_id].present?
      @m_users = @m_users.joins(:t_skills).where(t_skills: { id: params[:skill_id] })
    end

    if params[:location_id].present?
      @m_users = @m_users.where(location_id: params[:location_id])
    end

    # Apply pagination (adjust per-page count as needed)
    @m_users = @m_users.page(params[:page]).per(1)
  end

  def joblist
    @categories = TCategory.pluck(:title, :id)
    @skills     = TSkill.pluck(:title, :id)
    @locations  = TLocation.pluck(:city, :id)
    
    # Start with all job offers
    @joboffers = TJobOffer.all

    # Apply filters based on search form inputs
    if params[:category_id].present?
      @joboffers = @joboffers.where(category_id: params[:category_id])
    end

    if params[:min_salary].present?
      @joboffers = @joboffers.where("minsalary >= ?", params[:min_salary])
    end

    if params[:max_salary].present?
      @joboffers = @joboffers.where("maxsalary <= ?", params[:max_salary])
    end

    if params[:skill_id].present?
      @joboffers = @joboffers.joins(:t_skills).where(t_skills: { id: params[:skill_id] })
    end

    if params[:location_id].present?
      @joboffers = @joboffers.where(location_id: params[:location_id])
    end

    # Apply pagination (adjust per-page count as needed)
    @joboffers = @joboffers.page(params[:page]).per(1)
  end

end
