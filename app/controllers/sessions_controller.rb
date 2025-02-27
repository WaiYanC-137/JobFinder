class SessionsController < ApplicationController
  def new
    # Renders the login page
  end

  def create
    # Try to find the user or company by email
    @user = MUser.find_by(email: params[:email])
    @company = MCompany.find_by(email: params[:email])

    # If user exists and password is correct
    if @user && @user.authenticate(params[:password])
      log_in(@user)
      if params[:remember_me] == '1'
        remember(@user)
      else
        forget(@user)
      end
      redirect_to joblist_path, notice: "Logged in as user."
    
    # If company exists and password is correct
    elsif @company && @company.authenticate(params[:password])
      log_in(@company)
      if params[:remember_me] == '1'
        remember(@company)
      else
        forget(@company)
      end
      redirect_to userlist_path, notice: "Logged in as company."

    # If email or password is incorrect
    else
      flash.now[:alert] = "Email or password is incorrect."
      render :new
    end
  end

  def destroy
    if current_entity
      log_out
    end
    redirect_to login_path, notice: "Logged out."
  end

  private

  def log_in(entity)
    if entity.is_a?(MUser)
      session[:user_id] = entity.id
    elsif entity.is_a?(MCompany)
      session[:company_id] = entity.id
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

  def current_entity
    if session[:user_id]
      @current_entity = MUser.find_by(id: session[:user_id])
    elsif session[:company_id]
      @current_entity = MCompany.find_by(id: session[:company_id])
    elsif cookies.signed[:user_id]
      entity = MUser.find_by(id: cookies.signed[:user_id])
      if entity && entity.authenticated?(cookies[:remember_token])
        log_in(entity)
        @current_entity = entity
      end
    elsif cookies.signed[:company_id]
      entity = MCompany.find_by(id: cookies.signed[:company_id])
      if entity && entity.authenticated?(cookies[:remember_token])
        log_in(entity)
        @current_entity = entity
      end
    end
  end
end
