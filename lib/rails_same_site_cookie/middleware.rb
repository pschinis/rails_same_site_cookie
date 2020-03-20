require 'rails_same_site_cookie/user_agent_checker'

module RailsSameSiteCookie
  class Middleware

    COOKIE_SEPARATOR = "\n".freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      regex = RailsSameSiteCookie.configuration.user_agent_regex
      generate_legacy = RailsSameSiteCookie.configuration.generate_legacy_cookie
      set_cookie = headers['Set-Cookie']
      if (regex.nil? or regex.match(env['HTTP_USER_AGENT'])) and not (set_cookie.nil? or set_cookie.strip == '')
        parser = UserAgentChecker.new(env['HTTP_USER_AGENT'])
        if parser.send_same_site_none? || generate_legacy
          cookies = set_cookie.split(COOKIE_SEPARATOR)
          ssl = Rack::Request.new(env).ssl?

          cookies.each do |cookie|
            next if cookie == '' or cookie.nil?
            if ssl and not cookie =~ /;\s*secure/i
              cookie << '; Secure'
            end

            if parser.send_same_site_none?
              unless cookie =~ /;\s*samesite=/i
                cookie << '; SameSite=None'
              end
            end

            if generate_legacy
              cookie_name, cookie_value = cookie.split('=', 2)
              legacy_cookie = "#{COOKIE_SEPARATOR} #{cookie_name}-legacy=#{cookie_value}"
              cookie << legacy_cookie
            end
          end

          headers['Set-Cookie'] = cookies.join(COOKIE_SEPARATOR)
        end
      end

      [status, headers, body]
    end

  end
end