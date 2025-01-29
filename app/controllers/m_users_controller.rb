class MUsersController < ApplicationController
  def new
    @m_user = MUser.new
  end

  def create
    @m_user = MUser.new(m_user_params)
    if @m_user.save
      redirect_to loginforusers_path, notice: 'Account created successfully. Please log in.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def m_user_params
    params.require(:m_user).permit(:name, :email, :password, :password_confirmation)
  end
end
