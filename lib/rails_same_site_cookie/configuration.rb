module RailsSameSiteCookie
  class Configuration
    attr_accessor :user_agent_regex
    attr_accessor :resolve_prog_bool

    def initialize
      @user_agent_regex = nil
      @resolve_prog_bool = nil
    end
  end
end
