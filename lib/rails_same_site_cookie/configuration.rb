module RailsSameSiteCookie
  class Configuration
    VALUES = %w{Strict Lax None}

    attr_accessor :user_agent_regex
    attr_reader :default_value

    def initialize
      @user_agent_regex = nil
      @default_value = 'None'
    end

    def default_value=(raw_value)
      value = raw_value.to_s.camelcase
      raise ArgumentError, "invalid value (valid: #{VALUES})" unless VALUES.include?(value)
      @default_value = value
    end

  end
end
