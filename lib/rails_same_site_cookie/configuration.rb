module RailsSameSiteCookie
  class Configuration
    VALUES = %w{Strict Lax None}

    attr_accessor :user_agent_regex
    attr_reader :default_value

    def initialize
      @user_agent_regex = nil
      @default_value = 'None'
      @default_override = false
    end

    def default_value=(raw_value)
      value = raw_value.to_s.camelcase
      raise ArgumentError, "invalid value (valid: #{VALUES})" unless VALUES.include?(value)
      @default_value = value
    end

    def default_override=(boolean)
      raise ArgumentError, 'not boolean' unless [true, false].include?(boolean)
      @default_override = boolean
    end

    def allow_override?
      @default_override
    end
  end
end
