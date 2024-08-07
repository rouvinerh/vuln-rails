require 'net/http'

class Tenant2Controller < ApplicationController

  def login
  end

  def authenticate
    email = params[:email]
    password = params[:password]
    user = User.find_by_sql(["SELECT * FROM users WHERE email = ? AND password = ?", email, password]).first

    if user && user.password == ENV.fetch('FLAG')
      flash[:alert] = nil
      session[:user_id] = email
      redirect_to tenant2_dashboard_path
    else
      flash[:alert] = "Invalid email or password!"
      redirect_to tenant2_login_path
    end
  end

  def dashboard
    flash[:alert] = nil
    @user = User.find_by(email: session[:user_id])
    if @user && @user.email == ENV.fetch('TENANT2_EMAIL')
      render :dashboard
    else 
      flash[:alert] = "Please login!"
      redirect_to tenant2_login_path
    end
  end

  def reset_password
    if params[:email].present? && params[:data].present?
      begin
        user = User.find_by(email: params[:email])
        if user
          decoded_data = Base64.strict_decode64(params[:data])
          deserialized_data = Marshal.load(decoded_data)
          user.password = deserialized_data[:new_password]
          user.save!
          log_user_data(params[:data])
          redirect_to tenant2_login_path
        else
          flash[:alert] = "Error resetting password: User cannot be found."
          redirect_to tenant2_dashboard_path
        end
      rescue StandardError => e
        flash[:alert] = "Error resetting your password. #{e.message}"
        redirect_to tenant2_dashboard_path
      end
    else
      flash[:alert] = "Error resetting your password. Please make sure all fields are filled."
      redirect_to tenant2_dashboard_path
    end
  end

  private

  def authenticate_admin
    unless session[:admin_user]
      redirect_to admin_login_path, alert: "Please log in first."
    end
  end
  
  # send user data for logging elsewhere :D
  def log_user_data(data)
    begin
      log_data = Marshal.load(Base64.strict_decode64(data))
      uri = URI.parse("https://#{ENV.fetch('SIEM')}.#{ENV.fetch('HOST')}/logging")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = {data: log_data}.to_json
      request['Content-Type'] = 'application/json'
      response = http.request(request)
      if response.is_a?(Net::HTTPSuccess)
      else
      end
    rescue StandardError => e
    end
  end
end