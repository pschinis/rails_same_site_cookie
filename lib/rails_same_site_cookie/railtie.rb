require 'rails_same_site_cookie/middleware'

module RailsSameSiteCookie
  class Railtie < Rails::Railtie
    initializer "rails_same_site_cookie.setup_middleware" do
      Rails.application.middleware.insert_after ::Rack::Runtime, ::RailsSameSiteCookie::Middleware
    end
  end
end
