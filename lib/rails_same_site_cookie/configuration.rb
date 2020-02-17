module RailsSameSiteCookie
  class Configuration
    attr_accessor :user_agent_regex
    attr_accessor :user_filter

    def initialize
      @user_agent_regex = nil
      @user_filter = nil
    end
  end
end
