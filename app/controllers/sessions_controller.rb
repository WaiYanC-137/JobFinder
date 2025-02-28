class SessionsController < ApplicationController
  def new
    # Renders the login page
  end

  def create
    # Try to find the user by email first
    @user = MUser.find_by(email: params[:email])
  
    if @user
      # If user exists and password is correct
      if @user.authenticate(params[:password])
        log_in(@user)
        # Remember or forget the user based on the "remember_me" checkbox
        if params[:remember_me] == '1'
          remember(@user)
        else
          forget(@user)
        end
        redirect_to joblist_path, notice: "Logged in as user."
      else
        flash.now[:alert] = "Email or password is incorrect."
        render :new
      end
  
    # If user is not found, try to find the company by email
    else
      @company = MCompany.find_by(email: params[:email])
  
      if @company && @company.authenticate(params[:password])
        log_in(@company)
        # Remember or forget the company based on the "remember_me" checkbox
        if params[:remember_me] == '1'
          remember(@company)
        else
          forget(@company)
        end
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
