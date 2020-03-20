module RailsSameSiteCookie
  class Configuration
    attr_accessor :user_agent_regex, :generate_legacy_cookie

    def initialize
      @user_agent_regex = nil
      @generate_legacy_cookie = false
    end
  end
end