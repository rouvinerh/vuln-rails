# The new intern wrote this. Well done! (Yet to be approved by the security team)
class Tenant1Controller < ApplicationController
    def login
    end
  
    def authenticate
      begin
        email = params[:email].gsub(' ', '')
        password = params[:password].gsub(' ', '')
        
        sql = "SELECT 1 FROM users WHERE email='#{email}' AND password='#{password}'"
        result = ActiveRecord::Base.connection.execute(sql)
      
        if result && result.any?
          session[:user_id] = email
          redirect_to tenant1_dashboard_path
        else
          flash[:alert] = "Invalid email or password!"
          render :login
        end
      rescue StandardError => e
        flash[:alert] = "Error occurred."
        render :login
      end
    end
  
  
    def dashboard
      @user = User.find_by(email: session[:user_id])
      if @user && @user.email == ENV.fetch('TENANT1_EMAIL')
        render :dashboard
      else
        flash[:alert] = "Please login!"
        redirect_to tenant1_login_path
      end
    end
  end