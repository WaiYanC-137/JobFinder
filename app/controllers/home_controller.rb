class HomeController < ApplicationController

    def index

    end

    def register
    
    end

    def joblist
        @categories = TCategory.pluck(:title, :id)  
        @skills = TSkill.pluck(:title, :id)          
        @locations = TLocation.pluck(:city, :id) 
    end
end
