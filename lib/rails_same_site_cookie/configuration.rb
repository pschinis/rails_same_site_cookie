module RailsSameSiteCookie
  class Configuration
    VALUES = %w{Strict Lax None}

    attr_accessor :user_agent_regex

    def initialize
      @user_agent_regex = nil
      @default_value = 'None'
      @default_override = false
      @individual_settings = {}
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

    def individual_settings=(settings)
      settings.each do |name, options|
        cookie_name = name.to_s
        @individual_settings[cookie_name] = {}
        if options.present?
          if options.key?(:value)
            value = options[:value].to_s.camelcase
            raise ArgumentError, "invalid value (valid: #{VALUES})" unless VALUES.include?(value)
            @individual_settings[cookie_name][:value] = value
          end
          if options.key?(:override)
            raise ArgumentError, 'not boolean' unless [true, false].include?(options[:override])
            @individual_settings[cookie_name][:override] = options[:override]
          end
        end
      end
    end

    def value(cookie_name)
      @individual_settings.dig(cookie_name, :value) || @default_value
    end

    def allow_override?(cookie_name)
      override = @individual_settings.dig(cookie_name, :override)
      override.nil? ? @default_override : override
    end
  end
end
