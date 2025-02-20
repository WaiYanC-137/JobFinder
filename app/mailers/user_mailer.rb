class UserMailer < ApplicationMailer
     default from: 'aungmyintmo.kzy@gmail.com'  
  
    def registration_email(user)
      @user = user
      @url  = 'http://127.0.0.1:3000/login'  # Adjust the URL if needed, for example, to the login page.
      mail(to: @user.email, subject: 'Welcome to JobFinder!')  # Subject of the email
    end
  end
  