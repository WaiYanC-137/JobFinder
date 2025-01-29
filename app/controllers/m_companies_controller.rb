class MCompaniesController < ApplicationController
  def new
    @m_company = MCompany.new
  end

  def create
    @m_company = MCompany.new(m_company_params)

    # Check if the email already exists in the MUser table
    if MUser.exists?(email: @m_company.email)
      flash.now[:alert] = "このメールアドレスはすでにユーザーアカウントとして使用されています。"
      render :new, status: :unprocessable_entity
      return
    end

    # Proceed with saving the company if no conflicts
    if @m_company.save
      redirect_to login_path, notice: 'アカウントが作成されました。ログインしてください。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def m_company_params
    params.require(:m_company).permit(:name, :email, :phone, :password, :password_confirmation)
  end
end
