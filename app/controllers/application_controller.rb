class ApplicationController < ActionController::Base
  before_action :set_current_entity
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Helper methods to get the current user or company from the session
  helper_method :current_user, :current_company, :current_entity

  def current_user
    @current_user ||= MUser.find(session[:user_id]) if session[:user_id]
  end

  def current_company
    @current_company ||= MCompany.find(session[:company_id]) if session[:company_id]
  end

  def logged_in_user?
    current_user.present?
  end

  def logged_in_company?
    current_company.present?
  end

  def current_entity
    @current_entity ||= begin
      if session[:user_id]
        MUser.find_by(id: session[:user_id])
      elsif session[:company_id]
        MCompany.find_by(id: session[:company_id])
      elsif cookies.signed[:user_id]
        entity = MUser.find_by(id: cookies.signed[:user_id])
        if entity && entity.authenticated?(cookies[:remember_token])
          log_in(entity)
          entity
        end
      elsif cookies.signed[:company_id]
        entity = MCompany.find_by(id: cookies.signed[:company_id])
        if entity && entity.authenticated?(cookies[:remember_token])
          log_in(entity)
          entity
        end
      end
    end
  end

  def set_current_entity
    # You don't need to manually set @current_entity here anymore
    # The current_entity method handles caching
  end

  def log_in(entity)
    if entity.is_a?(MUser)
      session[:user_id] = entity.id
    elsif entity.is_a?(MCompany)
      session[:company_id] = entity.id
    end
  end
end
