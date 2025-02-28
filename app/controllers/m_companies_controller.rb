class MCompaniesController < ApplicationController
  before_action :authenticate_company!, only: [  :edit, :update, :edit_password, :update_password]

  def new
    @m_company = MCompany.new
  end

  def create
    @m_company = MCompany.new(m_company_params)

    # Check if the email already exists in the MUser or MCompany table
    if MUser.exists?(email: @m_company.email)
      flash.now[:alert] = "このメールアドレスはすでにユーザーアカウントとして使用されています。"
      render :new, status: :unprocessable_entity and return
    elsif MCompany.exists?(email: @m_company.email)
      flash.now[:alert] = "このメールアドレスはすでに会社アカウントとして使用されています。"
      render :new, status: :unprocessable_entity and return
    end

    # Proceed with saving the company if no conflicts
    if @m_company.save
      UserMailer.registration_email(@m_company).deliver_now
      redirect_to login_path, notice: 'アカウントが作成されました。ログインしてください。'
    else
      flash.now[:alert] = @m_company.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @m_company = MCompany.find(params[:id])
    @joboffers = @m_company.t_job_offers
                           .distinct
                           .order(created_at: :desc)
                           .page(params[:page])
                           .per(2)
  end

  def edit
    @m_company = MCompany.find(params[:id])
  end

  def update
    @m_company = MCompany.find(params[:id])
    @categories = TCategory.all 
    @skills = TSkill.all       
    @locations = TLocation.all
    # Check if the email already exists in the MUser table and not for the current company
    if MUser.exists?(email: m_company_params[:email])
      flash.now[:alert] = "このメールアドレスはすでにユーザーアカウントとして使用されています。"
      render :edit, status: :unprocessable_entity and return
    elsif MCompany.exists?(email: m_company_params[:email]) && m_company_params[:email] != @m_company.email
      flash.now[:alert] = "このメールアドレスはすでに会社アカウントとして使用されています。"
      render :edit, status: :unprocessable_entity and return
    end

    # Validate profile picture format if provided
    if params[:m_company][:logo].present?
      unless valid_image_format?(params[:m_company][:logo])
        flash.now[:alert] = "プロフィール画像は JPG または JPEG 形式のみ対応しています。"
        render :edit, status: :unprocessable_entity
        return
      end
    end
  
    # Update fields excluding password (unless provided)
    if m_company_params[:password].present?
      @m_company.password = m_company_params[:password]
      @m_company.password_confirmation = m_company_params[:password_confirmation] if m_company_params[:password_confirmation].present?
    end

    # Proceed with updating company attributes
    if @m_company.update(m_company_params)

      redirect_to m_company_path(@m_company), notice: '企業情報が更新されました。'
    else
      flash.now[:alert] = "更新に失敗しました。" + @m_company.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def edit_password
    @company = current_company
  end

  def update_password
    @company = current_company
    # Validate current password
    if @company.authenticate(params[:m_company][:current_password])
      if @company.update(password_params)
        flash[:success] = "Password updated successfully."
        redirect_to m_company_path(@company)  # Adjust to your profile or desired page
      else
        render :edit_password, status: :unprocessable_entity
      end
    else
      @company.errors.add(:current_password, "is incorrect")
      render :edit_password, status: :unprocessable_entity
    end
  end

  private

  # Check if the company is logged in
  def authenticate_company!
    unless current_company
      flash[:alert] = 'ログインしてください。'
      redirect_to login_path # Redirect to login if the company is not logged in
    end
  end
  
  def valid_image_format?(file)
    allowed_types = ["image/jpeg", "image/jpg" , "image/png"]
    allowed_types.include?(file.content_type)
  end

  def password_params
    params.require(:m_company).permit(:password, :password_confirmation)
  end

  def m_company_params
    params.require(:m_company).permit(:name, :email, :phone, :password, :password_confirmation, :location_id, :info, :address, :logo)
  end
end
