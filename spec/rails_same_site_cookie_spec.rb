RSpec.describe RailsSameSiteCookie do
  it "has a version number" do
    expect(RailsSameSiteCookie::VERSION).not_to be nil
  end

  it "responds to config" do
    RailsSameSiteCookie.configure do |config|
      expect(config.is_a?(RailsSameSiteCookie::Configuration)).to be(true)
      expect(config).to respond_to(:user_agent_regex)
      expect(config).to respond_to("user_agent_regex=")
      expect(config).to respond_to("default_value=")
      expect(config).to respond_to("default_override=")
      expect(config).to respond_to("individual_settings=")
      expect(config).to respond_to(:value)
      expect(config).to respond_to(:allow_override?)
    end
  end
end
