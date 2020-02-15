RSpec.describe RailsSameSiteCookie do
  it "has a version number" do
    expect(RailsSameSiteCookie::VERSION).not_to be nil
  end

  it "responds to config" do
    RailsSameSiteCookie.configure do |config|
      expect(config.is_a?(RailsSameSiteCookie::Configuration)).to be(true)
      expect(config).to respond_to(:user_agent_regex)
      expect(config).to respond_to("user_agent_regex=")
    end
  end
end
