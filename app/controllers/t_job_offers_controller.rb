class TJobOffersController < ApplicationController
  before_action :set_job_offer, only: %i[show edit update destroy]
  before_action :set_form_data, only: %i[new create edit update]

  def new
    @job_offer = TJobOffer.new(company: current_company)
  end

  def show
  end

  def create
    @job_offer = TJobOffer.new(job_offer_params)
    @job_offer.company = current_company
    if @job_offer.save
      redirect_to @job_offer, notice: 'Job offer was successfully created.'
    else
      flash.now[:alert] = @job_offer.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def edit
           
  end

  def update
    if @job_offer.update(job_offer_params)
      redirect_to @job_offer, notice: 'Job offer was successfully updated.'
    else
      flash.now[:alert] = @job_offer.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Optionally, ensure only the owner can delete the job offer:
    if @job_offer.company == current_company
      @job_offer.destroy
      redirect_to t_job_offers_path, notice: 'Job offer was successfully deleted.'
    else
      redirect_to @job_offer, alert: 'You are not authorized to delete this job offer.'
    end
  end

  def restrict
    # Find the job offer using the provided ID from the URL
    job_offer = TJobOffer.find(params[:id])

    # Toggle the restricted status
    if job_offer.restricted.nil? || job_offer.restricted == false 
      job_offer.update(restricted: true)  # Restrict applications
      flash[:notice] = "応募が制限されました。"  # "Applications have been restricted."
    else
      job_offer.update(restricted: false)  # Allow applications again
      flash[:notice] = "応募が再開されました。"  # "Applications have been reopened."
    end
    
    # Redirect back to the job offer page
    redirect_to job_offer
  end

  private

  def set_job_offer
    @job_offer = TJobOffer.find(params[:id])
  end

  def set_form_data
    @locations = TLocation.all.pluck(:city, :id)
    @categories = TCategory.all.pluck(:title, :id)
    @skills = TSkill.all# Ensure @skills is never nil
  end

  def job_offer_params
    params.require(:t_job_offer).permit(:title, :minsalary, :maxsalary, :location_id, :category_id, :description, t_skill_ids: [])
  end
end
