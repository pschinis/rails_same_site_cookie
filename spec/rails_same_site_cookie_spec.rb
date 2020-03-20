RSpec.describe RailsSameSiteCookie do
  it "has a version number" do
    expect(RailsSameSiteCookie::VERSION).not_to be nil
  end

  it "responds to config" do
    RailsSameSiteCookie.configuration do |config|
      expect(config.is_a?(RailsSameSiteCookie::Configuration)).to be(true)
      expect(config).to respond_to(:user_agent_regex)
      expect(config).to respond_to("user_agent_regex=")
      expect(config).to respond_to(:generate_legacy_cookie)
      expect(config).to respond_to("generate_legacy_cookie=")
    end
  end
end
