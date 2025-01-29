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

  def edit
    @m_user = MUser.find(params[:id])
  end

  def update
    @m_user = MUser.find(params[:id])

    # Check if the email already exists in the MCompany table
    if MCompany.exists?(email: @m_user.email) && @m_user.email != params[:m_user][:email]
      flash.now[:alert] = "このメールアドレスはすでに会社アカウントとして使用されています。"
      render :edit, status: :unprocessable_entity
      return
    end

    # Attempt to update the user record
    if @m_user.update(m_user_params)
      redirect_to m_user_path(@m_user), notice: 'ユーザー情報が更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def m_user_params
    params.require(:m_user).permit(:name, :phone, :job_type, :skill, :jigoshokai, :location, :profile)
  end
end
