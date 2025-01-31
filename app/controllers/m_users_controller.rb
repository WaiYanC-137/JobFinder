class MUsersController < ApplicationController
  def new
    @m_user = MUser.new
  end

  def create
    @m_user = MUser.new(m_user_params)

    # Check if the email already exists in the MCompany table and Musers tabel
    if MCompany.exists?(email: m_user_params[:email])
      flash.now[:alert] = "このメールアドレスはすでに会社アカウントとして使用されています。"
      render :new, status: :unprocessable_entity
      return
    elsif MUser.exists?(email: m_user_params[:email])
      flash.now[:alert] = "このメールアドレスはすでにユーザーアカウントとして使用されています。"
      render :new, status: :unprocessable_entity
      return
    end
  

    # Proceed with saving the user if no conflicts
    if @m_user.save
      redirect_to login_path, notice: 'アカウントが作成されました。ログインしてください。'
    else
      flash.now[:alert] = "アカウントが作成されませんでした。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @m_user = MUser.find(params[:id])
  end

  def update
    @m_user = MUser.find(params[:id])
  
    # Check if the email already exists in the MCompany table and not for the current user
    if MCompany.exists?(email: m_user_params[:email])
      flash.now[:alert] = "このメールアドレスはすでに会社アカウントとして使用されています。"
      render :edit, status: :unprocessable_entity
      return
    # Check if the email already exists in the MUser table but exclude the current user's email
    elsif MUser.exists?(email: m_user_params[:email]) && m_user_params[:email] != @m_user.email
      flash.now[:alert] = "このメールアドレスはすでにユーザーアカウントとして使用されています。"
      render :edit, status: :unprocessable_entity
      return
    end
  
    # Proceed with updating the user
    if @m_user.update(m_user_params)
      redirect_to m_user_path(@m_user), notice: 'ユーザー情報が更新されました。'
    else
      flash.now[:alert] = "Failed"
      render :edit, status: :unprocessable_entity
    end
  end
  
  
  
  private

  def m_user_params
    params.require(:m_user).permit(:name, :email, :about, :phone, :category, :location, :profile_picture, skill_ids: [])
  end
  
end
