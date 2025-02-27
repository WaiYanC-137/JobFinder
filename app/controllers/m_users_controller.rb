class MUsersController < ApplicationController
  # Ensure that user is authenticated for edit, update, and show actions
  before_action :authenticate_user!, only: [:edit, :update, :edit_password_user, :update_password]

  def new
    @m_user = MUser.new
  end

  def create
    @m_user = MUser.new(m_user_params)

    # Check if the email already exists in the MCompany table and MUser table
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
      UserMailer.registration_email(@m_user).deliver_now 
      Rails.logger.info "Email sent."
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
    puts "##Editttt"
    @m_user = MUser.find(params[:id])
    @categories = TCategory.all 
    @skills = TSkill.all       
    @locations = TLocation.all
    puts @m_user.inspect
    puts "edit cagteogry #{@categories.inspect}"
  end

  def update
    @m_user = MUser.find(params[:id])
    @categories = TCategory.all 
    @skills = TSkill.all       
    @locations = TLocation.all
  
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
  
    # Validate profile picture format if provided
    if params[:m_user][:profile_picture].present?
      unless valid_image_format?(params[:m_user][:profile_picture])
        flash.now[:alert] = "プロフィール画像は JPG または JPEG 形式のみ対応しています。"
        render :edit, status: :unprocessable_entity
        return
      end
    end
  
    # Update user attributes
    if @m_user.update(m_user_params)
      if m_user_params[:t_skill_ids].present?
        @m_user.t_skills = TSkill.where(id: m_user_params[:t_skill_ids])
      else
        @m_user.t_skills.clear
      end
      redirect_to m_user_path(@m_user), notice: 'ユーザー情報が更新されました。'
    else
      flash.now[:alert] = @m_user.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end
  
  

  def edit_password_user
    @user = current_user
  end

  def update_password
    @user = current_user
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

  def apply_job_offer
    @job_offer = TJobOffer.find(params[:job_offer_id])
    
    # Check if the current user has already applied to this job offer
    if current_user.t_job_offers.exists?(@job_offer.id)
      flash[:alert] = "You have already applied to this job offer."
    else
      # Associate the job offer with the user
      current_user.t_job_offers << @job_offer
      flash[:notice] = "You have successfully applied to the job offer."
    end

    redirect_to t_job_offer_path(@job_offer)
  end

  private
  def password_params
    params.require(:m_user).permit(:password, :password_confirmation)
  end

  def valid_image_format?(file)
    allowed_types = ["image/jpeg", "image/jpg"]
    allowed_types.include?(file.content_type)
  end

  def m_user_params
    params.require(:m_user).permit(:name, :email, :password, :password_confirmation, :about, :phone, :category_id, :location_id, :profile_picture, t_skill_ids: [])
  end
  
  def authenticate_user!
    # If the user is not logged in, redirect to the login page
    unless current_user
      redirect_to login_path, alert: "ログインしてください"
    end
  end
end
