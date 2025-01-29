class MCompaniesController < ApplicationController
  def new
    @m_company = MCompany.new
  end

  def create
    @m_company = MCompany.new(m_company_params)
    if @m_company.save
      redirect_to loginforcompanies_path, notice: 'Account created successfully. Please log in.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def m_company_params
    params.require(:m_company).permit(:name, :email, :password, :password_confirmation)
  end
end
