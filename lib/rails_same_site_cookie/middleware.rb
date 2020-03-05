require 'rails_same_site_cookie/user_agent_checker'

module RailsSameSiteCookie
  class Middleware

    COOKIE_SEPARATOR = "\n".freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      if sets_cookie?(headers) && user_agent_matches?(env['HTTP_USER_AGENT'])
        parser = UserAgentChecker.new(env['HTTP_USER_AGENT'])
        if parser.send_same_site_none?
          cookies = headers['Set-Cookie'].split(COOKIE_SEPARATOR)
          ssl = Rack::Request.new(env).ssl?

          cookies.each do |cookie|
            next if cookie.empty?
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

    def regex
      RailsSameSiteCookie.configuration.user_agent_regex
    end

    def sets_cookie?(headers)
      headers['Set-Cookie'].is_a?(String) && !headers['Set-Cookie'].empty?
    end

    def user_agent_matches?(user_agent)
      return true if regex.nil?

      regex.match(user_agent)
    end
  end
end