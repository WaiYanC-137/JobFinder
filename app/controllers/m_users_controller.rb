class MUsersController < ApplicationController
  def new
    @m_user = MUser.new
  end

  def create
    @m_user = MUser.new(m_user_params)

    # Check if the email already exists in the MCompany table
    if MCompany.exists?(email: @m_user.email)
      flash.now[:alert] = "このメールアドレスはすでに会社アカウントとして使用されています。"
      render :new, status: :unprocessable_entity
      return
    end

    # Proceed with saving the user if no conflicts
    if @m_user.save
      redirect_to login_path, notice: 'アカウントが作成されました。ログインしてください。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def m_user_params
    params.require(:m_user).permit(:name, :email, :password, :password_confirmation)
  end
end
