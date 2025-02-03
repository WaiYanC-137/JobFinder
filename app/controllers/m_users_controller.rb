class MUsersController < ApplicationController
  def new
    @m_user = MUser.new
  end

  def create
    @m_user = MUser.new(m_user_params)

    # Check if the email already exists in the MCompany table and Musers tabel
    if MCompany.exists?(email: m_user_params[:email])
      flash.now[:alert] = "このメールアドレスはすでに会社アカウントとして使用されています。" +@m_user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
      return
    elsif MUser.exists?(email: m_user_params[:email])
      flash.now[:alert] = "このメールアドレスはすでにユーザーアカウントとして使用されています。" +@m_user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
      return
    end
  

    # Proceed with saving the user if no conflicts
    if @m_user.save
      redirect_to login_path, notice: 'アカウントが作成されました。ログインしてください。' +@m_user.errors.full_messages.join(", ")
    else
      flash.now[:alert] = "アカウントが作成されませんでした。" +@m_user.errors.full_messages.join(", ")
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
  
    # Update fields excluding password (unless provided)
    if m_user_params[:password].present?
      # Only update password if it's provided
      @m_user.password = m_user_params[:password]
      @m_user.password_confirmation = m_user_params[:password_confirmation] if m_user_params[:password_confirmation].present?
    end
  
    # Proceed with updating user attributes, including category_id and location_id
    if @m_user.update(
      name: m_user_params[:name],
      about: m_user_params[:about],
      phone: m_user_params[:phone],
      category_id: m_user_params[:category_id],  # Corrected to category_id
      location_id: m_user_params[:location_id],  # Corrected to location_id
      profile_picture: m_user_params[:profile_picture]
    )
      # Ensure skills are properly updated
    if m_user_params[:t_skill_ids].present?
      @m_user.t_skills = TSkill.where(id: m_user_params[:t_skill_ids]) # REPLACES existing skills
    else
      @m_user.t_skills.clear # Removes all skills if no skill_ids are provided
    end
  
      redirect_to m_user_path(@m_user), notice: 'ユーザー情報が更新されました。'
    else
      flash.now[:alert] = "更新に失敗しました。" + @m_user.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end
  
  
  
  
  
  
  private

  def m_user_params
    params.require(:m_user).permit(:name, :email, :password, :password_confirmation, :about, :phone, :category_id, :location_id, :profile_picture, t_skill_ids: [])
  end
  
end
