Rails.application.routes.draw do
  constraints subdomain: ENV.fetch('TENANT1') do
    root 'tenant1#login', as: 'tenant1_login'
    post 'authenticate', to: 'tenant1#authenticate', as: 'tenant1_authenticate'
    get 'dashboard', to: 'tenant1#dashboard', as: 'tenant1_dashboard'
  end

  constraints subdomain: ENV.fetch('TENANT2') do
    root 'tenant2#login', as: 'tenant2_login'
    post 'authenticate', to: 'tenant2#authenticate', as: 'tenant2_authenticate'
    get 'dashboard', to: 'tenant2#dashboard', as: 'tenant2_dashboard'
    post 'reset_password', to: 'tenant2#reset_password', as: 'tenant2_reset_password'
  end

  constraints(lambda { |req| req.subdomains.empty? }) do
    root to: redirect(subdomain: ENV.fetch('TENANT1'), host: ENV.fetch('HOST'))
  end

  match '*path', to: 'application#not_found', via: :all
end
