module RailsSameSiteCookie
  class Configuration
    attr_accessor :user_agent_regex
    attr_accessor :env_bool_condition

    def initialize
      @user_agent_regex = nil
      @env_bool_condition = nil
    end
  end
end
