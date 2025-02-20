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
      flash.now[:alert] = @m_user.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @m_user = MUser.find(params[:id])
    @joboffers = @m_user.t_job_offers.order(created_at: :desc).page(params[:page]).per(2)

  end


  def edit
    @m_user = MUser.find(params[:id])
    @categories = TCategory.all 
    @skills = TSkill.all       
    @locations = TLocation.all
  end

  def update
    @m_user = MUser.find(params[:id])
  
    # Check if the email already exists in MCompany and MUser (excluding current user's email)
    if MCompany.exists?(email: m_user_params[:email])
      flash.now[:alert] = "このメールアドレスはすでに会社アカウントとして使用されています。"
      render :edit, status: :unprocessable_entity
      return
    elsif MUser.exists?(email: m_user_params[:email]) && m_user_params[:email] != @m_user.email
      flash.now[:alert] = "このメールアドレスはすでにユーザーアカウントとして使用されています。"
      render :edit, status: :unprocessable_entity
      return
    end
  
    # Attach the new profile picture if it's provided
    if params[:m_user][:profile_picture].present?
      @m_user.profile_picture.attach(params[:m_user][:profile_picture])
    end
  
    # Update user attributes, including the new profile picture (if attached)
    if @m_user.update(m_user_params)
      # Handle updating skills
      if m_user_params[:t_skill_ids].present?
        @m_user.t_skills = TSkill.where(id: m_user_params[:t_skill_ids]) # Replaces existing skills
      else
        @m_user.t_skills.clear # Removes all skills if no skill_ids are provided
      end
      redirect_to m_user_path(@m_user), notice: 'ユーザー情報が更新されました。'
    else
      flash.now[:alert] = @m_user.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end
  def edit_password_user
    @user = current_company
  end
  def update_password
    @user = current_company
    # Validate current password
    if @user.authenticate(params[:m_user][:current_password])
      if @user.update(password_params)
        flash[:success] = "Password updated successfully."
        redirect_to m_user_path(@user)  # Adjust to your profile or desired page
      else
        render :edit_password, status: :unprocessable_entity
      end
    else
      @user.errors.add(:current_password, "is incorrect")
      render :edit_password, status: :unprocessable_entity
    end
  end

  private
  def password_params
    params.require(:m_user).permit(:password, :password_confirmation)
  end
  def m_user_params
    params.require(:m_user).permit(:name, :email, :password, :password_confirmation, :about, :phone, :category_id, :location_id, :profile_picture, t_skill_ids: [])
  end
  
end
