class ApplicationController < ActionController::Base
  before_action :restrict_access

  def not_found
    render plain: "404 Not Found", status: :not_found
  end

  private
  def restrict_access
    if !allowed_routes.include?(request.path)
      render plain: "404 Not Found", status: :not_found
    end
  end

  def allowed_routes
    [
      tenant1_login_path,
      tenant1_authenticate_path,
      tenant1_dashboard_path,
      tenant2_login_path,
      tenant2_authenticate_path,
      tenant2_dashboard_path,
      tenant2_reset_password_path
    ]
  end


end