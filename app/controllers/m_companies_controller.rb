class MCompaniesController < ApplicationController
  def new
    @m_company = MCompany.new
  end

  def create
    @m_company = MCompany.new(m_company_params)
  
    # Check if the email already exists in the MUser or MCompany table
    if MUser.exists?(email: @m_company.email)
      flash.now[:alert] = "このメールアドレスはすでにユーザーアカウントとして使用されています。"
      render :new, status: :unprocessable_entity and return
      return
    elsif MCompany.exists?(email: @m_company.email)
      flash.now[:alert] = "このメールアドレスはすでに会社アカウントとして使用されています。"
      render :new, status: :unprocessable_entity and return
      return
    end
  
    # Proceed with saving the company if no conflicts
    if @m_company.save
      redirect_to login_path, notice: 'アカウントが作成されました。ログインしてください。'
    else
      flash.now[:alert] = @m_company.errors.full_messages
      render :new, status: :unprocessable_entity and return
    end
  end
  
  def show
    @m_company=MCompany.find(params[:id])
    @joboffers = @m_company.t_job_offers
                      .joins(:m_users)    # This joins job offers with m_users; a job offer with multiple m_users yields multiple rows.
                      .distinct           # Ensures that each job offer appears only once in the result set.
                      .order(created_at: :desc)
                      .page(params[:page])
                      .per(2)
  end
  def edit
    @m_company = MCompany.find(params[:id])
  end

  def update
    @m_company = MCompany.find(params[:id])
  
    # Check if the email already exists in the MUser table and not for the current company
    if MUser.exists?(email: m_company_params[:email])
      flash.now[:alert] = "このメールアドレスはすでにユーザーアカウントとして使用されています。"
      render :edit, status: :unprocessable_entity
      return
    # Check if the email already exists in the MCompany table but exclude the current company's email
    elsif MCompany.exists?(email: m_company_params[:email]) && m_company_params[:email] != @m_company.email
      flash.now[:alert] = "このメールアドレスはすでに会社アカウントとして使用されています。"
      render :edit, status: :unprocessable_entity
      return
    end
  
    # Update fields excluding password (unless provided)
    if m_company_params[:password].present?
      @m_company.password = m_company_params[:password]
      @m_company.password_confirmation = m_company_params[:password_confirmation] if m_company_params[:password_confirmation].present?
    end
  
    # Proceed with updating company attributes
    if @m_company.update(
        name: m_company_params[:name],
        phone: m_company_params[:phone],
        location_id: m_company_params[:location_id],
        address: m_company_params[:address],
        info: m_company_params[:info],
        logo: m_company_params[:logo]
      )
  
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
  def password_params
    params.require(:m_company).permit(:password, :password_confirmation)
  end
  def m_company_params
    params.require(:m_company).permit(:name, :email, :phone, :password, :password_confirmation, :location_id, :info, :address, :logo)
  end
end
