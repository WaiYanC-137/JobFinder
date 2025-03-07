class ApplicationController < ActionController::Base
  before_action :current_entity

  # Helper methods to get the current user or company from the session or cookies
  helper_method :current_user, :current_company, :current_entity, :logged_in_user?, :logged_in_company?

  # Check for current user from session
  def current_user
    @current_user ||= MUser.find(session[:user_id]) if session[:user_id]
  end

  # Check for current company from session
  def current_company
    @current_company ||= MCompany.find(session[:company_id]) if session[:company_id]
  end

  # Check if user is logged in
  def logged_in_user?
    current_user.present?
  end

  # Check if company is logged in
  def logged_in_company?
    current_company.present?
  end

  # Check if a user or company is logged in, handle auto-login via cookies
  def current_entity
    @current_entity ||= begin
      if session[:user_id]
        MUser.find_by(id: session[:user_id])
      elsif session[:company_id]
        MCompany.find_by(id: session[:company_id])
      elsif cookies.signed[:user_id] && cookies[:remember_token]
        user = MUser.find_by(id: cookies.signed[:user_id])
        if user && user.authenticated?(cookies[:remember_token])
          log_in(user)
          user
        end
      elsif cookies.signed[:company_id] && cookies[:remember_token]
        company = MCompany.find_by(id: cookies.signed[:company_id])
        if company && company.authenticated?(cookies[:remember_token])
          log_in(company)
          company
        end
      end
    end
  end

  # Log in a user or company
  def log_in(entity)
    if entity.is_a?(MUser)
      session[:user_id] = entity.id
      cookies.permanent.signed[:user_id] = entity.id
      cookies.permanent[:remember_token] = entity.remember_token
    elsif entity.is_a?(MCompany)
      session[:company_id] = entity.id
      cookies.permanent.signed[:company_id] = entity.id
      cookies.permanent[:remember_token] = entity.remember_token
    end
  end

  # Log out user or company and clear cookies
  def log_out
    session.delete(:user_id)
    session.delete(:company_id)
    cookies.delete(:user_id)
    cookies.delete(:company_id)
    cookies.delete(:remember_token)
  end

  private

  # Allow browser versions (if needed for browser compatibility or versions)
  def allow_browser_versions
    # Logic for handling browser versions (you can add version-based checks if necessary)
  end
end
