class PasswordResetsController < ApplicationController
    def new
      # Show the form where the user enters their email
    end
  
    def create
      # Try to find a user or company by the provided email address
      @user = MUser.find_by(email: params[:email].downcase)
      @company = MCompany.find_by(email: params[:email].downcase) unless @user
  
      # Set entity to either user or company
      entity = @user || @company
  
      if entity
        # Generate a reset token and hash it before saving
        reset_token = SecureRandom.urlsafe_base64
        reset_digest = BCrypt::Password.create(reset_token)
        entity.update(reset_digest: reset_digest, reset_sent_at: Time.zone.now)
  
        # Send password reset email with the token using UserMailer
        send_password_reset(entity, reset_token)
  
        flash[:info] = "Password reset instructions have been sent to your email."
        redirect_to root_path
      else
        flash[:danger] = "Email not found."
        render 'new'
      end
    end
  
    def send_password_reset(entity, reset_token)
      # Use UserMailer for both users and companies
      UserMailer.password_reset(entity, reset_token).deliver_now
    end
  
    def edit
      # Find user or company by email (since email is unique)
      @user = MUser.find_by(email: params[:email])
      @company = MCompany.find_by(email: params[:email])
    
      # Debugging output
      Rails.logger.debug "User: #{@user.inspect}"
      Rails.logger.debug "Company: #{@company.inspect}"
    
      # Set entity to either user or company
      entity = @user || @company
    
      # Check if the entity exists and the reset token is valid
      if entity
        Rails.logger.debug "Entity found: #{entity.inspect}"
        if valid_token?(entity, params[:token])
          render :edit
        else
          flash[:danger] = "Invalid or expired token."
          redirect_to passwordreset_path
        end
      else
        flash[:danger] = "User or company not found."
        redirect_to passwordreset_path
      end
    end
    
    
  
    def update
      # Find user or company
      @user = MUser.find_by(email: params[:email])
      @company = MCompany.find_by(email: params[:email])
    
      entity = @user || @company
    
      # Debugging output
      Rails.logger.debug "Params: #{params.inspect}"
      Rails.logger.debug "Entity: #{entity.inspect}"
    
      if entity && password_params_present?
        if entity.update(password_params)
          flash[:success] = "Password has been reset!"
          redirect_to login_path
        else
          flash.now[:danger] = entity.errors.full_messages.join(", ")
          render 'edit'
        end
      else
        flash.now[:danger] = "Invalid user or password is missing."
        render 'edit'
      end
    end
    
  
    private
  
    def password_params
      params.permit(:password, :password_confirmation)
    end
  
    def password_params_present?
      params[:password].present? && params[:password_confirmation].present?
    end
    
  
    def valid_token?(entity, token)
      # Safely check if the reset token is valid
      begin
        BCrypt::Password.new(entity.reset_digest).is_password?(token)
      rescue BCrypt::Errors::InvalidHash
        false
      end
    end
  end
  