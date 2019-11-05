module RailsSameSiteCookie
  class Configuration
    attr_accessor :user_agent_regex

    def initialize
      @user_agent_regex = nil
    end
  end
end