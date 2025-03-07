class MUsersController < ApplicationController
  # Ensure that user is authenticated for edit, update, and show actions
  before_action :authenticate_user!, only: [:edit, :update, :edit_password, :update_password]

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
      redirect_to new_m_user_path, notice: 'アカウントが作成されました。ログインしてください。' 
    else
      flash.now[:alert] = @m_user.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @m_user = MUser.find(params[:id])
    @joboffers = @m_user.t_job_offers.order(created_at: :desc).page(params[:page]).per(3)
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
  

  def edit_password
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
  def moshikomi
    @job_offer = TJobOffer.find(params[:job_offer_id])
    @m_user=current_user
  end
  def apply_job_offer
    @m_user = current_user  # Get the currently logged-in user
    @job_offer = TJobOffer.find(params[:job_offer_id])  # Find the job offer
  
    # First, check if the user already has a resume attached
    if @m_user.resume.attached?
      # If resume is attached, proceed to save the user and associate with the job offer
      if @m_user.save
        @job_offer.m_users << @m_user
  
        redirect_to @job_offer, notice: '履歴書が正常にアップロードされ、応募が完了しました。'
      else
        render :apply_job_offer, alert: '履歴書のアップロードに失敗しました。'
      end
    # If no resume is attached, check if a new file is being uploaded
    elsif params[:m_user][:resume].present?
      # Attach the uploaded resume to the user
      @m_user.resume.attach(params[:m_user][:resume])
  
      # Save the user and associate with the job offer
      if @m_user.save
        @job_offer.m_users << @m_user
  
        redirect_to @job_offer, notice: '履歴書が正常にアップロードされ、応募が完了しました。'
      else
        render :apply_job_offer, alert: '履歴書のアップロードに失敗しました。'
      end
    else
      # If no resume is provided and none is attached, show an error
      redirect_to @job_offer, alert: '履歴書を選択してください。'
    end
  end
  
  


  private
  def password_params
    params.require(:m_user).permit(:password, :password_confirmation)
  end

  def valid_image_format?(file)
    allowed_types = ["image/jpeg", "image/jpg" , "image/png"]
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
