require 'rails_same_site_cookie/user_agent_checker'

module RailsSameSiteCookie
  class Middleware

    COOKIE_SEPARATOR = "\n".freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      if should_intercept?(env, headers)
        parser = UserAgentChecker.new(env['HTTP_USER_AGENT'])
        if parser.send_same_site_none?
          cookies = headers['Set-Cookie'].split(COOKIE_SEPARATOR)
          ssl = Rack::Request.new(env).ssl?

          cookies.each do |cookie|
            next if cookie.blank?
            if ssl and not cookie =~ /;\s*secure/i
              cookie << '; Secure'
            end

            unless cookie =~ /;\s*samesite=/i
              cookie << '; SameSite=None'
            end

          end

          headers['Set-Cookie'] = cookies.join(COOKIE_SEPARATOR)
        end
      end

      [status, headers, body]
    end

    private

    def should_intercept?(env, headers)
      regex = RailsSameSiteCookie.configuration.user_agent_regex
      user_filter = RailsSameSiteCookie.configuration.user_filter
      result = headers['Set-Cookie'].present? && (regex.nil? || regex.match(env['HTTP_USER_AGENT']))

      return result unless user_filter.respond_to?(:call)
      result && user_filter.call(env)
    end

  end
end
