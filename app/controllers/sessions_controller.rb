class SessionsController < ApplicationController
    def new
      @entity_type = params[:type] # Determine if it's a user or company login
    end
  
    def create
      if params[:type] == "user"
        user = MUser.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          session[:user_id] = user.id
          session[:user_type] = "user"
          redirect_to root_path, notice: "User logged in successfully"
        else
          flash[:alert] = "Invalid email or password"
          render :new, status: :unprocessable_entity
        end
      elsif params[:type] == "company"
        company = MCompany.find_by(email: params[:email])
        if company&.authenticate(params[:password])
          session[:company_id] = company.id
          session[:user_type] = "company"
          redirect_to root_path, notice: "Company logged in successfully"
        else
          flash[:alert] = "Invalid email or password"
          render :new, status: :unprocessable_entity
        end
      else
        flash[:alert] = "Invalid login type"
        redirect_to root_path
      end
    end
  
    def destroy
      session[:user_id] = nil
      session[:company_id] = nil
      session[:user_type] = nil
      redirect_to root_path, notice: "Logged out successfully"
    end
  end
  