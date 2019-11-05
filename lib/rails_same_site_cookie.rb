require "rails_same_site_cookie/version"
require "rails_same_site_cookie/configuration"
require "rails_same_site_cookie/railtie" if defined?(Rails)

module RailsSameSiteCookie
  class Error < StandardError; end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

end
