class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
    # Helper methods to get the current user or company from the session
    helper_method :current_user, :current_company
  
    def current_user
      # Assuming you're using sessions to store the user ID
      @current_user ||= MUser.find(session[:user_id]) if session[:user_id]
    end
  
    def current_company
      # Assuming you're using sessions to store the company ID
      @current_company ||= MCompany.find(session[:company_id]) if session[:company_id]
    end
  
    def logged_in_user?
      current_user.present?
    end
  
    def logged_in_company?
      current_company.present?
    end
  
  
end
