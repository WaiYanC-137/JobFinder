class PasswordResetsController < ApplicationController
    def new
      # Show the form where the user enters their email
    end
  
    def create
      @user = MUser.find_by(email: params[:email].downcase)
      
      if @user
        reset_token = SecureRandom.urlsafe_base64
        reset_digest = BCrypt::Password.create(reset_token)  # Hash the token before saving it
        @user.update(reset_digest: reset_digest, reset_sent_at: Time.zone.now)
    
        UserMailer.password_reset(@user, reset_token).deliver_now
        flash[:info] = "Password reset instructions have been sent to your email."
        redirect_to root_path
      else
        flash[:danger] = "Email not found."
        render 'new'
      end
    end
  
    def edit
  @user = MUser.find_by(id: params[:id])  # Find user by ID

  if @user && BCrypt::Password.new(@user.reset_digest).is_password?(params[:token])
    render :edit
  else
    flash[:danger] = "Invalid or expired token."
    redirect_to passwordreset_path
  end
end

  
def update
    @user = MUser.find_by(id: params[:id])
    
    if @user && params[:m_user][:password].present?
      if @user.update(password_params)
        flash[:success] = "Password has been reset!"
        redirect_to login_path
      else
        flash.now[:danger] = @user.errors.full_messages.join(", ")
        render 'edit'
      end
    else
      flash.now[:danger] = "Invalid user or password is missing."
      render 'edit'
    end
  end
  
  private
  def password_params
    params.require(:m_user).permit(:password, :password_confirmation)
  end  
  end
  