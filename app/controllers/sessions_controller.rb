class SessionsController < ApplicationController
  def new
    # Login page
  end

  def create
    # Try finding the email in both tables
    @user = MUser.find_by(email: params[:email])
    @company = MCompany.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to joblist_path, notice: 'Logged in as user.'
    elsif @company&.authenticate(params[:password])
      session[:company_id] = @company.id
      redirect_to userlist_path, notice: 'Logged in as company.'
    else
      flash.now[:alert] = 'Email or password is incorrect.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:company_id] = nil
    redirect_to login_path, notice: 'Logged out.'
  end
end
