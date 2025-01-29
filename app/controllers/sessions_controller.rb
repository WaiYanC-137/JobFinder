class SessionsController < ApplicationController
    def new
      # This renders the login form (new.html.erb)
    end
  
    def create
      user = MUser.find_by(email: params[:email]) # Find user by email
      
      if user&.authenticate(params[:password]) # Check if password is correct
        session[:user_id] = user.id # Store user ID in session
        redirect_to root_path, notice: "Logged in successfully"
      else
        flash[:alert] = "Invalid email or password"
        render :new, status: :unprocessable_entity # Re-render login form
      end
    end
  
    def destroy
      session[:user_id] = nil # Clear the session
      redirect_to root_path, notice: "Logged out successfully"
    end
  end
  