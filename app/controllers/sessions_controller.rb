class SessionsController < ApplicationController
  def new
    # Renders the login page
  end

  def create
    # Validate email presence
    if params[:email].blank?
      flash.now[:alert] = error_message(:blank, :email)
      render :new and return
    end

    # Validate email format
    unless params[:email] =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]{2,}\z/i
      flash.now[:alert] = error_message(:invalid, :email)
      render :new and return
    end

    # Validate password presence and length
    if params[:password].blank?
      flash.now[:alert] = error_message(:blank, :password)
      render :new and return
    end

    if params[:password].length < 6
      flash.now[:alert] = error_message(:too_short, :password, count: 6)
      render :new and return
    elsif params[:password].length > 20
      flash.now[:alert] = error_message(:too_long, :password, count: 20)
      render :new and return
    end

    # Try to find the user by email first
    @user = MUser.find_by(email: params[:email])

    if @user
      # If user exists and password is correct
      if @user.authenticate(params[:password])
        log_in(@user)
        remember_user_or_company(@user)
        redirect_to joblist_path, notice: "Logged in as user."
      else
        flash.now[:alert] = "Email or password is incorrect."
        render :new
      end
    else
      # If user is not found, try to find the company by email
      @company = MCompany.find_by(email: params[:email])
      if @company && @company.authenticate(params[:password])
        log_in(@company)
        remember_user_or_company(@company)
        redirect_to userlist_path, notice: "Logged in as company."
      else
        flash.now[:alert] = "Email or password is incorrect."
        render :new
      end
    end
  end

  def destroy
    if current_entity
      log_out
    end
    redirect_to login_path, notice: "Logged out."
  end

  private

  # Updated helper method to build error messages manually
  def error_message(type, attribute, count: nil)
    message = ERROR_MESSAGES[type]
    attribute_label = ATTRIBUTES[attribute]
    
    # Substitute count if needed
    message = count ? message % { count: count } : message

    "#{attribute_label}#{message}"
  end

  def remember_user_or_company(entity)
    if params[:remember_me] == '1'
      remember(entity)
    else
      forget(entity)
    end
  end

  def remember(entity)
    entity.remember
    if entity.is_a?(MUser)
      cookies.permanent.signed[:user_id] = entity.id
    elsif entity.is_a?(MCompany)
      cookies.permanent.signed[:company_id] = entity.id
    end
    cookies.permanent[:remember_token] = entity.remember_token
  end

  def forget(entity)
    entity.forget
    cookies.delete(:user_id)
    cookies.delete(:company_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_entity)
    session.delete(:user_id)
    session.delete(:company_id)
    @current_entity = nil
  end
end
