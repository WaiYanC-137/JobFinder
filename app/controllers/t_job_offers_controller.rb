class TJobOffersController < ApplicationController
  before_action :set_job_offer, only: %i[show]
  before_action :set_form_data, only: %i[new create]
    def new
        @job_offer = TJobOffer.new(company: current_company) # Automatically associate the current company
    end
    def show

    end
    def create
      @job_offer = TJobOffer.new(job_offer_params)
      @job_offer.company = current_company # Automatically assign the logged-in company
      if @job_offer.save
        
        redirect_to @job_offer, notice: 'Job offer was successfully created.'
      else
        flash.now[:alert] = @job_offer.errors.full_messages
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_job_offer
      @job_offer = TJobOffer.find(params[:id])
    end
  
    def set_form_data
      @locations = TLocation.all.pluck(:city, :id)
      @categories = TCategory.all.pluck(:title, :id)
      @skills = TSkill.all
    end
  
    def job_offer_params
      params.require(:t_job_offer).permit(:title, :minsalary, :maxsalary, :location_id, :category_id, :description, t_skill_ids: [])
    end
  end
  